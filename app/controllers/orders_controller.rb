class OrdersController < ApplicationController
include CustomAuthorization
    before_action :authenticate_user!
    before_action :authorize_role,only: [:index,:update]

    def index 
        @pagy_pending_orders, @pending_orders = pagy(Order.where(status: 'pending').order('created_at DESC'), items: 15)
        @pagy_in_progress_orders, @in_progress_orders = pagy(Order.where(status: 'progress').order('created_at DESC'), items: 15)
        @pagy_completed_orders, @completed_orders = pagy(Order.where(status: 'completed').order('created_at DESC'), items: 15)    
    end

    def create 
        @order = current_user.orders.build(total_price: calculate_total_price, status: 'pending')
        @order.save
        current_user.cart.cart_products.each do |cart_product|
            OrderItem.create(order: @order, product:cart_product.product, quantity:cart_product.quantity)
        end
        current_user.cart.cart_products.destroy_all
        flash[:notice] = 'Order was successfully created.'
        redirect_to root_path

    end

    def show_orders 
       @pagy, @orders = pagy(current_user.orders.order('created_at DESC'),items:10)
    end

    def update
        @order = Order.find(params[:id])
      
        if @order.update(order_params)
          flash[:notice] = 'Order status was successfully updated.'
        else
          flash[:alert] = 'Failed to update order status.'
        end
      
        redirect_to orders_path
    end

    private
    def calculate_total_price
        total_price = 0
    
        current_user.cart.cart_products.each do |cart_product|
          # Calculate the price for each cart product and add it to the total.
          total_price += cart_product.product.price * cart_product.quantity
        end
    
        total_price
      end
    def order_params
        params.require(:order).permit(:status)
    end
end
