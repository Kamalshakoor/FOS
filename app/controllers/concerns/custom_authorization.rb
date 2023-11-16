module CustomAuthorization
    def authorize_admin
        unless current_user.role == 'admin'
          flash[:alert] = "You are not authorized to perform this action."
          redirect_to root_path
        end
    end 
end