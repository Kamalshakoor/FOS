class RemoveRatingAndCommentFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :rating, :integer
    remove_column :orders, :comment, :text
  end
end
