class Product < ApplicationRecord
    has_one_attached :image
    has_many :cart_products
    has_many :carts, through: :cart_products
    belongs_to :category
    has_many :order_items
    has_many :ratings
end
