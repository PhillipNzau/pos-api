class Product < ApplicationRecord
    has_one :product_inventory
    has_many :product_categories, dependent: :destroy
    has_many :categories, through: :product_categories, dependent: :destroy
end
  