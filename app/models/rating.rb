class Rating < ApplicationRecord
  belongs_to :order
  belongs_to :user
  belongs_to :product
end
