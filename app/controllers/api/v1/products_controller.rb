class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  before_action :authorized, except: %i[index show]
  before_action :authorize_admin, only: %i[create destroy update]

  # GET /products
  def index
    @products = Product.all
    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    product = Product.new(product_params)

    if product.save
      product_inventory = create_product_inventory(product)
      categories = create_product_categories(product)

      render json: { product: product, inventory: product_inventory, categories: categories }, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    product = Product.find(params[:id])
    product.product_categories.destroy_all
  
    if product.destroy
      render json: { message: 'Product and its associations have been deleted' }, status: :no_content
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :barcode, :stock_quantity, :restock_alert_threshold, category_ids: [])
    end

    def create_product_inventory(product)
      product_inventory = ProductInventory.new(
        product: product,
        stock_quantity: params[:stock_quantity],
        restock_alert_threshold: params[:restock_alert_threshold]
      )
      product_inventory.save
      product_inventory
    end

    def create_product_categories(product)
      category_ids = params[:category_ids]
      categories = Category.where(id: category_ids)
      product.categories << categories
      categories
    end
end
