class ApplicationController < ActionController::API
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  def authenticate_user
    api_key = request.headers["Authorization"]&.split(' ')&.last
end
