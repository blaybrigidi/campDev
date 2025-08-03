class SessionsController < ApplicationController
    def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            render json: {message: "Login Successful", user: user}, status: :ok
        else
            render json: {message: "Incorrect Email or Password"}, status: :unauthorized
        end
    end
end