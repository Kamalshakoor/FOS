class RatingsController < ApplicationController
    def new 
        @rating = Rating.new
        @order = Order.find(params[:order_id])
        # @product = Product.find(params[:product_id])
    end

    def create 
    end
end
