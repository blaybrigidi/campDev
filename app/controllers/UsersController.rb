class UsersController < ApplicationController
  before_action :authenticate_user, except: [ :create ]
    def create
      user = User.new(user_params)

      if user.save
        render json: { message: "Signup Successful", user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      if params[:id].to_i == @current_user.id
        render json: { user: { id: @current_user.id, name: @current_user.name, email: @current_user.email, phone_number: @current_user.phone_number, year: @current_user.year } }
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
    
    def update
      if params[:id].to_i == @current_user.id
        if @current_user.update(user_update_params)
          render json: { message: "Profile updated successfully", user: { id: @current_user.id, name: @current_user.name, email: @current_user.email, phone_number: @current_user.phone_number, year: @current_user.year } }, status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :year, :password, :phone_number)
    end
    
    def user_update_params
      params.require(:user).permit(:name, :email, :year, :phone_number)
    end
end
