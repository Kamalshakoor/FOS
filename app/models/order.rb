class Order < ApplicationRecord
  enum status: ['pending','progress','completed']
  belongs_to :user
  has_many :order_items, dependent: :destroy
end
