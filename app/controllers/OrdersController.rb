class OrdersController < ApplicationController
  before_action :authenticate_user
    def index
    orders = @current_user.orders
    if orders.any?
      render json: orders
    else
      render json: { message: "You have no orders" }
    end
  end
  def by_user
    orders = @current_user.orders
    if orders.any?
      render json: { message: "Orders retrieved successfully", orders: orders }, status: :ok
    else
      render json: { message: "No orders found" }, status: :ok
    end
  end
  
  # View all pending orders from all users (marketplace)
  def marketplace
    pending_orders = Order.where(order_status: 'pending', service_provider_id: nil)
                         .includes(:user)
                         .order(created_at: :desc)
    
    orders_with_user = pending_orders.map do |order|
      order.as_json.merge(
        'requester' => {
          'name' => order.user.name,
          'year' => order.user.year
        }
      )
    end
    
    render json: { orders: orders_with_user }
  end
  
  # Accept an order (become the service provider)
  def accept_order
    order = Order.find_by(id: params[:id])
    
    if order.nil?
      render json: { message: "Order not found" }, status: :not_found
      return
    end
    
    if order.user_id == @current_user.id
      render json: { message: "You cannot accept your own order" }, status: :unprocessable_entity
      return
    end
    
    if order.service_provider_id.present?
      render json: { message: "Order already accepted by someone else" }, status: :unprocessable_entity
      return
    end
    
    if order.order_status != 'pending'
      render json: { message: "Order is no longer available" }, status: :unprocessable_entity
      return
    end
    
    order.service_provider_id = @current_user.id
    order.order_status = 'accepted'
    
    if order.save
      render json: { message: "Order accepted successfully", order: order }, status: :ok
    else
      render json: { message: "Failed to accept order", errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # View orders I'm providing service for
  def my_services
    service_orders = Order.where(service_provider_id: @current_user.id)
                         .includes(:user)
                         .order(created_at: :desc)
    
    orders_with_requester = service_orders.map do |order|
      order.as_json.merge(
        'requester' => {
          'name' => order.user.name,
          'phone_number' => order.user.phone_number
        }
      )
    end
    
    render json: { orders: orders_with_requester }
  end
      
    
  def create
    order = @current_user.orders.build(order_params)
    if order.save
      render json: { message: "Order Created Successfully", order: order }, status: :created
    else
      render json: { error: order.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def show
    order = @current_user.orders.find_by(id: params[:id])
    if order
      render json: order
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end
  
    
  def update_order
    order = @current_user.orders.find_by(id: params[:id])
    if order.nil?
      render json: { message: "This order does not exist" }, status: :not_found
      return
    end
  
    if order.order_status == "pending"
      order.order_status = "processing"
    else
      order.order_status = "completed"
    end
  
    if order.save
      render json: { message: "Order status successfully updated", status: order.order_status }, status: :ok
    else
      render json: { message: "Failed to update order status", errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end
    
  def cancel
    order = @current_user.orders.find_by(id: params[:id])
    if order.nil?
      render json: { message: "Order does not exist" }, status: :not_found
      return
    end
    order.order_status = "cancelled"
    if order.save
      render json: { message: "Order cancelled successfully" }, status: :ok
    else
      render json: { message: "Failed to cancel order" }, status: :unprocessable_entity
    end
  end

  def update
    order = @current_user.orders.find_by(id: params[:id])
    if order.nil?
      render json: { message: "Order not found" }, status: :not_found
      return
    end
    if order.update(order_update_params)
      render json: { message: "Order saved successfully" }, status: :ok
    else
      render json: { message: "Failed to update Order", error: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    order = @current_user.orders.find_by(id: params[:id])
    if order.nil?
      render json: { message: "Order does not exist" }, status: :not_found
      return
    end
    if order.destroy
      render json: { message: "Order successfully deleted" }, status: :ok
    else
      render json: { message: "Order failed to delete", errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end



  private
  
  def order_params
    params.require(:order).permit(:item_name, :order_status, :location)
  end
  
  def order_update_params
    params.require(:order).permit(:location, :item_name)
  end
  end
  