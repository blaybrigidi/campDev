class OrdersController < ApplicationController
    def create
      order = Order.new(order_params)
      if order.save
        render json: { message: "Order Created Successfully" }, status: :created
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      order = Order.find(params[:id])
      render json: order
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Order not found" }, status: :not_found
    end
  
    private
  
    def order_params
      params.require(:order).permit(:item_name, :order_status, :user_id, :location)
    end
  end
  