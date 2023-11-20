class CartController < ApplicationController
include CustomAuthorization
before_action :authenticate_user!
      
    
# def add_to_cart 
    #     product = Product.find(params[:product_id])
    #     if product
    #         # puts product.inspect
    #         @cart = Cart.find_or_initialize_by(user_id: current_user.id)
    #         # puts @cart.products.inspect
    #         puts @cart.inspect
    #         @cart.product_id = product.id
    #         @cart.user_id = current_user.id
    #         quantity = params[:quantity].to_i
    #         @cart.quantity = quantity
    #         @cart.save
    #         # puts @cart.inspect
    #         flash[:notice] = 'Product Added Successfully'
    #         redirect_to root_path
    #     else
    #         flash[:notice] = 'Somethind Went wrong. Try again Later'
    #         redirect_to product_path(product)
#     end

# # if product
    # #     #     # check if user has already cart items or this is first one
    # #     #     existing_cart = Cart.find_by(user_id: current_user.id)
    # #     #     if existing_cart
    # #     #         @cart.product_id = product.id
    # #     #         @cart.user_id = current_user.id
    # #     #         quantity = params[:quantity].to_i
    # #     #         @cart.quantity = quantity
    # #     #         existing_cart << @cart
    # #     #         existing_cart.save
    # #     #         # will code later
    # #     #         flash[:notice] = 'Product Added'
    # #     #         redirect_to product_path(product)
    # #     #     else
    # #     #         @cart = Cart.new(user_id: current_user.id)
    # #     #         @cart.product_id = product.id
    # #     #         @cart.user_id = current_user.id
    # #     #         quantity = params[:quantity].to_i
    # #     #         @cart.quantity = quantity
    # #     #         @cart.save
    # #     #         # puts @cart.inspect
    # #     #         flash[:notice] = 'Product Added Successfully'
    # #     #         redirect_to root_path
    # #     #     end
    # #     # end

       
# end
      

    def add_to_cart
        product = Product.find(params[:product_id])
      
        if product
          # Find cart or initialize a new one 
            @cart = Cart.find_or_initialize_by(user_id: current_user.id)

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
        @cart_entries = Cart.where(user_id: current_user.id)
        render 'show_cart'
    end 

    def destroy 
        cart_record = Cart.find(params[:id]) 
        cart_record.delete
        redirect_to cart_path
    end
end
