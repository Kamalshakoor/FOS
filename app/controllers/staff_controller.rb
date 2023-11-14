class StaffController <  ApplicationController
    before_action :authenticate_admin, only: [:new, :create, :index, :destroy]
  
    # Index action to list staff members
    def index
        @staff_members = User.where(role: 'staff').order(created_at: :desc)
    end
  
    # New action to display the staff creation form
    def new
      @staff_member = User.new
    end
  
    # Create action to handle staff creation form submission
    def create
      @staff_member = User.new(staff_params)
      @staff_member.role = 'staff' # Set the role to 'staff'
  
      if @staff_member.save
        flash[:notice] = 'Staff member was successfully created.'
        redirect_to staff_index_path
      else
        render :new
      end
    end
  
    # Destroy action to delete staff members
    def destroy
      @staff_member = User.find(params[:id])
      if @staff_member.destroy
        flash[:notice] = 'Staff member was successfully deleted.'
      else
        flash[:alert] = 'Failed to delete staff member.'
      end
      redirect_to staff_index_path
    end
  
    private
  
    def staff_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
    def authenticate_admin
      # Add your authentication logic here to check if the user is an admin
      unless current_user.admin?
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
    end
  end
  