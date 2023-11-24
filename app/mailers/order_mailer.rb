class OrderMailer < ApplicationMailer
    def order_placed_email(user,order)
        @user = user
        @order = order
        mail(to: @user.email, subject: 'Your Order has been placed!')
    end
end
