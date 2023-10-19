class CreateProductInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :product_inventories do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :stock_quantity
      t.integer :restock_alert_threshold

      t.timestamps
    end
  end
end
