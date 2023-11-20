class OrdersController < ApplicationController
include CustomAuthorization
    before_action :authenticate_user!
    before_action :authorize_role,only: [:index]

    def index 
        @pagy, @orders = pagy(Order.all.order('created_at DESC'),items:15)
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

    private
    def calculate_total_price
        total_price = 0
    
        current_user.cart.cart_products.each do |cart_product|
          # Calculate the price for each cart product and add it to the total.
          total_price += cart_product.product.price * cart_product.quantity
        end
    
        total_price
      end
end
