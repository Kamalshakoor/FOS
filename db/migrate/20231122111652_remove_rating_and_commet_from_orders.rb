class RemoveRatingAndCommetFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :comment, :text
    remove_column :orders, :rating, :integer
  end
end
