class ProductInventoriesController < ApplicationController
  before_action :set_product_inventory, only: %i[ show update destroy ]

  # GET /product_inventories
  def index
    @product_inventories = ProductInventory.all

    render json: @product_inventories
  end

  # GET /product_inventories/1
  def show
    render json: @product_inventory
  end

  # POST /product_inventories
  def create
    @product_inventory = ProductInventory.new(product_inventory_params)

    if @product_inventory.save
      render json: @product_inventory, status: :created, location: @product_inventory
    else
      render json: @product_inventory.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_inventories/1
  def update
    if @product_inventory.update(product_inventory_params)
      render json: @product_inventory
    else
      render json: @product_inventory.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_inventories/1
  def destroy
    @product_inventory.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_inventory
      @product_inventory = ProductInventory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_inventory_params
      params.require(:product_inventory).permit(:product_id, :stock_quantity, :restock_alert_threshold)
    end
end
