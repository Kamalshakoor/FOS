class AddAdressRatingCommentToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :address, :string
    add_column :orders, :rating, :integer, default: nil
    add_column :orders, :comment, :text, default: nil
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
