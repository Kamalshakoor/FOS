class CategoriesController < ApplicationController
    include CustomAuthorization
    before_action :authenticate_user! , except: [:show]
    before_action :authorize_admin, except: [:show]
    before_action :set_params, only: [:show,:edit, :update, :destroy] 


    def index 
        @categories = Category.all.order('created_at DESC')
    end

    def new 
        @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        if (@category.save)
            flash[:notice] = "Category Added Successfully!"
            redirect_to categories_path
        else
            flash[:alert] = "Oops! Something went wrong. Try again!"
            render 'new'
        end
    end

    def edit    
    end

    def update 
        if @category.update(category_params)
            flash[:notice] = "Category Updated Successfully!"
            redirect_to categories_path
        else
            flash[:alert] = "Oops! Something went wrong. Try again!"
            redirect_to edit_path
        end

    end

    def destroy 
        if @category.destroy
            flash[:notice] = "Category Deleted Successfully!"
            redirect_to categories_path
        else
            flash[:alert] = "Oops! Something went wrong. Try again!"
            redirect_to categories_path
        end
    end



    private 
     def category_params 
        params.require(:category).permit(:name)
     end

     def set_params 
        @category = Category.find(params[:id])
     end

end
