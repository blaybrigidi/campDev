class SessionsController < ApplicationController
    def login
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        render json: { message: "Login Successful", api_key: user.api_key, user: { id: user.id, name: user.name, email: user.email } }, status: :ok
      else
        render json: { message: "Incorrect Email or Password" }, status: :unauthorized
      end
    end
end
