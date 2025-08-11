class MessagesController < ApplicationController
  before_action :authenticate_user
  before_action :find_order
  before_action :authorize_order_participant

  def index
    messages = @order.messages.includes(:user).ordered

    render json: {
      messages: messages.map do |message|
        {
          id: message.id,
          text: message.text,
          sender_id: message.user.id,
          sender_name: message.user.name,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
      end
    }
  end

  def create
    message = @order.messages.build(message_params)
    message.user = @current_user

    if message.save
      render json: {
        id: message.id,
        text: message.text,
        sender_id: message.user.id,
        sender_name: message.user.name,
        created_at: message.created_at,
        updated_at: message.updated_at
      }, status: :created
    else
      render json: {
        error: message.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  private

  def find_order
    @order = Order.find_by(id: params[:order_id])
    if @order.nil?
      render json: { error: "Order not found" }, status: :not_found
    end
  end

  def authorize_order_participant
    return if @order.nil?
    
    # Only allow requester and service provider to access messages
    unless @current_user.id == @order.user_id || @current_user.id == @order.service_provider_id
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end

  def message_params
    params.require(:message).permit(:text)
  end
end