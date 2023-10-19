class ProductInventorySerializer < ActiveModel::Serializer
  attributes :id, :stock_quantity, :restock_alert_threshold
  has_one :product
end
