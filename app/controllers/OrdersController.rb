class OrdersController < ApplicationController
    def index
        orders = Order.all
        if orders.any?
            render json: orders
        else
            render json: { message: "There are currently no ongoing orders" }
        end
      end
      def by_user
        user = User.find_by(id: params[:user_id])
        if user.nil?
          render json: { message: "User not found" }, status: :not_found
          return
        end

        orders = Order.where(user_id: user.id)
        Rails.logger.info("Orders found: #{orders.count}")

        if orders.any?
          render json: { message: "Orders retrieved successfully for #{user.name}", orders: orders }, status: :ok
        else
          render json: { message: "No orders for #{user.name}" }, status: :ok
        end
      end


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


    def update_order
      order = Order.find_by(id: params[:id])
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
      order = Order.find_by(id: params[:id])
      if order.nil?
        render json: { message: "Order does not exist" }, status: :not_found
        return
      end
      order.order_status = "cancelled"
      if order.save
        render json: { message: "Order cancelled successfuly" }, status: :ok
      else
        render json: { message: "Failed to cancel order" }, status: :unprocessable_entity
      end
    end

    def update
      order = Order.find(params[:id])
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
      order = Order.find_by(id: params[:id])
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
      params.require(:order).permit(:item_name, :order_status, :user_id, :location)
    end
      def order_update_params
        params.require(:order).permit(:location, :item_name)
      end
end
