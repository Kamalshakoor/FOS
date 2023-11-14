class ProductsController < ApplicationController
    before_action :set_params, only: [:edit, :update, :show, :destory] 
    before_action :authenticate_user!,only: [:create,:index,:edit, :update, :destroy]
    before_action :authorize_admin, only: [:new,:create, :edit, :update, :destroy, :index]

    def home 
        @products = Product.all.order('created_at DESC')
    end
    def index 
        @products = Product.all.order('created_at DESC')
    end
    def show 
    end
    def new 
        @product = Product.new 
    end

    def edit 
        # puts @product.inspect
    end

    def create 
        @product = Product.new(product_params)
        if(@product.save)
            flash[:notice] = 'Product was Successfully created'
            redirect_to products_path
        else
          render :new
        end
    end

    def update 
        if @product.update(product_params)
            flash[:notice] = 'Product Updated Successfully'
            redirect_to products_path
        else
            redirect_to edit_path
        end
    end

    def destroy
        @product.destroy
        redirect_to products_path
    end

    private

        def authorize_admin
            unless current_user.role == 'admin'
              flash[:alert] = "You are not authorized to perform this action."
              redirect_to root_path
            end
        end 

    def product_params
        params.require(:product).permit(:name,:description,:price,:image)
    end

    def set_params
        @product = Product.find(params[:id])
    end

end
