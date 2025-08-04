class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
    def create
      user = User.new(user_params)

      if user.save
        render json: { message: "Signup Successful", user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      user = User.find(params[:id])
      render json: user
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :year, :password, :phone_number)
    end
end
