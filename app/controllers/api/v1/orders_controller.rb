class Api::V1::OrdersController < ApplicationController
  # before_action :set_product, only: %i[show update destroy]
  before_action :authorized
  before_action :authorize_admin, only: %i[destroy update]
  # Create a new order
  def create
    order = current_user.orders.build(order_params)

    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Checkout action
  def checkout
    product_ids = params[:product_ids]
  
    # Check if product_ids is an array
    if product_ids.is_a?(Array)
      # Find the user's latest order that is still pending
      order = current_user.orders.where(status: 'pending').last
  
      if order.nil?
        # If no pending order exists, create a new one
        order = current_user.orders.build(status: 'pending')
      end
  
      product_ids.each do |product_id|
        product = Product.find(product_id)
  
        if product
          order.products << product
          product_inventory = product.product_inventory
  
          if product_inventory.stock_quantity > 0
            product_inventory.update(stock_quantity: product_inventory.stock_quantity - 1)
          else
            render json: { error: "Product #{product.name} is out of stock" }, status: :unprocessable_entity
            return
          end
        else
          render json: { error: "Product with ID #{product_id} not found" }, status: :not_found
          return
        end
      end
  
      if order.save
        order.update(status: 'completed') # Add this line to mark the order as completed
        render json: order, serializer: OrderSerializer
      else
        render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid product_ids parameter. It should be an array of product IDs' }, status: :bad_request
    end
  end

  # Checkout history action
  def checkout_history
    orders = current_user.orders.where(status: 'completed')

    checkout_history = orders.map do |order|
      {
        order: order,
        products: order.products,
        total_price: order.products.sum(:price)
      }
    end

    render json: checkout_history
  end

  private

  def order_params
    params.require(:order).permit(:status) # Adjust this based on your order attributes
  end
end
