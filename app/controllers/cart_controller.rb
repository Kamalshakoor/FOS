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

        
            # Check if the cart table already contain product for current user
            existing_item = Cart.find_by(product_id: product.id, user_id: current_user.id)
        
            if existing_item
                # byebug
                # If the product is already in the cart, update its quantity
                existing_item.quantity += params[:quantity].to_i
                existing_item.save
            else
                # If the product is not in the cart, add it
                new_item = Cart.new(product_id: product.id, user_id: current_user.id)
                new_item.quantity = params[:quantity].to_i
                new_item.save
            end
            flash[:notice] = 'Product Added Successfully'
            redirect_to root_path
        else
          flash[:notice] = 'Something Went Wrong. Try Again Later'
          redirect_to product_path(params[:product_id])
        end
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
