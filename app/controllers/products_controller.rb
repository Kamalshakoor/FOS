class ProductsController < ApplicationController
    include CustomAuthorization
    before_action :set_params, only: [:edit, :update, :show, :destroy] 
    before_action :authenticate_user!,only: [:create,:index,:edit, :update, :destroy]
    before_action :authorize_admin, only: [:new,:create, :edit, :update, :destroy, :index]

    def home 
        @recent_products = Product.order(created_at: :desc).limit(6)
        @random_products = Product.order("RANDOM()").limit(6)
        @pagy, @products = pagy(Product.all.order('created_at DESC'), items: 15)
    end

    def index 
        @pagy, @products = pagy(Product.all.order('created_at DESC'), items: 10)
    end
    
    def show 
        @same_category_product = Product.where(category_id: @product.category).order("RANDOM()").limit(3)
        @order_items = @product.order_items.includes(:order)
        # byebug
        # Initialize arrays to store ratings and comments
        @ratings = []
        @comments = []
        # Iterate through the associated order items
        @order_items.each do |order_item|
            # Check if the order item has a rating and comment
            if order_item.rating.present?
            @ratings << order_item.rating
            end
            
            if order_item.comment.present?
            @comments << order_item.comment
            end
        end




        # puts @same_category_product.inspect
    end
    def new 
        @product = Product.new 
        @categories = Category.all
    end

    def edit 
        # puts @product.inspect
        @categories = Category.all
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
        # byebug
        if @product.update(product_params)
            flash[:notice] = 'Product Updated Successfully'
            redirect_to products_path
        else
            redirect_to edit_path
        end
    end

    def destroy        
        # Find and remove the product from all user carts
        Cart.joins(:cart_products).where(cart_products: { product_id: @product.id }).each do |cart|
          cart.products.delete(@product)
        end
      
        if @product.destroy
          flash[:notice] = 'Product Deleted Successfully'
        else
          flash[:alert] = 'Failed to delete the product'
        end
      
        redirect_to products_path
      end
      


      def search
        @query = params[:query]
        @results = Product.where("name LIKE ?", "%#{@query}%")
        if @results.empty?
            redirect_to root_path
            flash[:alert] = "No matching products found."
        end
      end

    private

    def product_params
        params.require(:product).permit(:name,:description,:price,:image,:category_id)
    end

    def set_params
        @product = Product.find(params[:id])
    end

end
