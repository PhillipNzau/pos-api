class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :barcode
  has_one :product_inventory
  has_many :categories
end
