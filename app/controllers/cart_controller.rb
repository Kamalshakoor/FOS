class CartController < ApplicationController
include CustomAuthorization
before_action :authenticate_user!
      


    def add_to_cart
        product = Product.find(params[:product_id]) 

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
          cart.save!
          redirect_to cart_path, notice: 'Product added to cart successfully.'

    end

    def show_cart
        @cart = current_user.cart
        if @cart
        @cart_items = @cart.products
        else
        @cart_items = []
        end
    end

    def update_cart_quantity
      product = Product.find_by(id: params[:product_id])
      cart_product = current_user.cart.cart_products.find_by(product_id: product.id)
  
      if cart_product
        new_quantity = params[:quantity].to_i
        cart_product.update(quantity: new_quantity)
         # Fetch updated cart information
        total_items = current_user.cart.cart_products.sum(:quantity)
        subtotal = current_user.cart.cart_products.sum { |cp| cp.quantity * cp.product.price }
        tax = 0.0 # Adjust the tax calculation as needed
        total = subtotal + tax

        render json: {
          success: true,
          message: 'Quantity updated successfully.',
          total_items: total_items,
          subtotal: subtotal,
          tax: tax,
          total: total
        }
      else
        render json: { success: false, message: 'Cart product not found.' }
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
