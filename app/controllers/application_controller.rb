class ApplicationController < ActionController::API
before_action :authorized

#Creates a new token when called
def encode_token(payload)
    JWT.encode(payload, 'osheet')
end

#Fetch requests require this header
def auth_header
    request.headers['Authorization']
end

# Checks for the second item in the array inside the field of 'token' in this header 
def decoded_token
if auth_header
    token = auth_header.split(' ')[1]
begin
    JWT.decode(token, 'osheet', true, algorithm: 'HS256')
rescue JWT::DecodeError
    nil
  end 
 end
end

#Searches for a user in the database and sets @user to the selected user
def logged_in_user
    if decoded_token
        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
    end
end

#Does not make the program look for a user if oe is already logged in
def logged_in?
    !logged_in_user
end

#Checks if a user has already been authenticated
def authorized
    render json: {message: 'Please Log In' }, status: :unauthorized unless logged_in?
end

end
