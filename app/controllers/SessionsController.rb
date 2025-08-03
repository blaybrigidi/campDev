class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:login]
    def login
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        render json: { message: "Login Successful", user: user }, status: :ok
      else
        render json: { message: "Incorrect Email or Password" }, status: :unauthorized
      end
    end
  end
  