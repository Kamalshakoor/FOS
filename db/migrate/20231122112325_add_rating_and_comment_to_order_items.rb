class AddRatingAndCommentToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :rating, :integer
    add_column :order_items, :comment, :text
  end
end
