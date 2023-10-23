# app/serializers/order_serializer.rb

class OrderSerializer < ActiveModel::Serializer
    attributes :id, :status, :created_at, :updated_at  # Include any other order attributes you want to expose
  end
  