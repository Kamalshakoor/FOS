class CartController < ApplicationController
include CustomAuthorization
before_action :authenticate_user!
      
    def add_to_cart
        product = Product.find(params[:product_id]) # Assuming you pass the product ID in the URL

        # Find or create a cart for the current user
        cart = current_user.cart || current_user.build_cart

        # Check if the product is already in the cart
        cart_product = cart.cart_products.find_by(product_id: product.id)

        if cart_product
        # If the product is already in the cart, update the quantity
        cart_product.update(quantity: cart_product.quantity + 1)
        else
        # If the product is not in the cart, add it to the cart with the specified quantity
        cart.products << product
        # cart_product = cart.cart_products.find_by(product_id: product.id)
        # cart_product.update(quantity: params[:quantity].to_i)
        end

        redirect_to cart_path(cart), notice: 'Product added to cart successfully.'
    end

    def show_cart
        @cart = current_user.cart
        if @cart
        @cart_items = @cart.products
        else
        @cart_items = []
        end
    end

    def destroy
        @product = Product.find(params[:id])
        @cart = current_user.cart
      
        if @cart.products.include?(@product)
          @cart.products.delete(@product)
          flash[:notice] = 'Item removed from the cart'
        else
          flash[:alert] = 'Item not found in the cart'
        end
      
        redirect_to cart_path
    end
    
  
end
