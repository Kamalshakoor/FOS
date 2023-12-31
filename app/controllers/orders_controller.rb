class OrdersController < ApplicationController
include CustomAuthorization
    before_action :authenticate_user!
    before_action :authorize_role,only: [:index,:update]
    skip_before_action :verify_authenticity_token, only: [:process_payment]

    def index 
        @pagy_pending_orders, @pending_orders = pagy(Order.where(status: 'pending').order('created_at DESC'), items: 15)
        @pagy_in_progress_orders, @in_progress_orders = pagy(Order.where(status: 'progress').order('created_at DESC'), items: 15)
        @pagy_completed_orders, @completed_orders = pagy(Order.where(status: 'completed').order('created_at DESC'), items: 15)    
    end

    def create 
        @order = current_user.orders.build(total_price: calculate_total_price, status: 'pending')
        @order.save
        session[:address] = params[:address]
        current_user.cart.cart_products.each do |cart_product|
            OrderItem.create(order: @order, product:cart_product.product, quantity:cart_product.quantity)
        end
        redirect_to payment_form_order_path(@order)
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


    def payment_form
      @order = Order.find(params[:id])
    end
    

    def process_payment
      @order = Order.find(params[:id])
      @address = session[:address]
      stripe_token = params[:stripe_token]
    
      begin
        charge = Stripe::Charge.create(
          amount: (@order.total_price * 100).to_i, # Amount in cents
          currency: 'usd',
          source: stripe_token,
          description: 'Payment for order'
        )

        # If the charge is successful cart will be deleted
        @order.update(address: @address)
        current_user.cart.cart_products.destroy_all
        flash[:notice] = 'Order was successfully created and paid for.'
        OrderMailer.order_placed_email(current_user, @order).deliver_now
        redirect_to root_path
      rescue Stripe::CardError => e
        flash[:alert] = e.message
        render :payment_form
      end
    end

      def feedback
        @order = Order.find(params[:id]) 
      end

      def submit_feedback
        order_id = params[:order_id]
      
        # Find all the OrderItems associated with the given order_id
        order_items = OrderItem.where(order_id: order_id)
      
        if order_items.empty?
          flash[:notice] = "No order items found for the given order ID."
          redirect_to root_path
        else
          # Check if any of the order items already have a rating greater than zero
          if order_items.any? { |item| item.rating && item.rating > 0 }
            flash[:notice] = "You have already submitted a rating for one or more order items in this order."
            redirect_to root_path
          else
            # Update the ratings and comments for all order items in the order
            if order_items.update_all(rating: params[:rating], comment: params[:comment])
              redirect_to root_path, notice: "Ratings and comments submitted successfully for all order items."
            else
              flash[:notice] = "Something went wrong!"
              redirect_to root_path
            end
          end
        end
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
