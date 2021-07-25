class UsersController < ApplicationController
    #Checks that the user has been authenticated before any other actions are taken, only stepping aside for auto-login
    before_action :authorized, only: [:auto_login]

    # New User Creation
    def create
        @user  = User.create(user_params)
        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json {user: @user, token: token}, status: :created
        else
            redner json: {error: "Invalid user name or password"}, status: :not_acceptable
        end
    end

    end
    
    # User Login
    def login
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json { user: UserSerializer.new(@user), token: token }, status: :accepted
        else
            render json: { error: "Invalid Username or Password"}, status: :unauthorized
        end
    end

    def auto_login
        render json: { user: UserSerializer.new(@user)}, status: :accepted
    end


    private

    def user_params
        params.permit(:username, :password)
    end

end
