class ProductsController < ApplicationController
    before_action :set_params, only: [:edit, :update, :show, :destory] 

    def index 
        @product = Product.all.order('created_at DESC')
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
            redirect_to root_path, notice: 'Product was successfully created.'
        else
          render :new
        end
    end

    def update 
        if @product.update(product_params)
            redirect_to root_path, notice: 'Product Updated Successfully'
        else
            redirect_to edit_path
        end
    end

    def destroy
        @product.destroy
        redirect_to root_path
    end

    private

    def product_params
        params.require(:product).permit(:name,:description,:price,:image)
    end

    def set_params
        @product = Product.find(params[:id])
    end

end
