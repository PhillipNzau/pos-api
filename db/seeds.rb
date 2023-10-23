# db/seeds/seed_data.rb
require 'faker'
# Create admin user
admin = User.create(first_name: 'Admin', last_name: 'User', email: 'admin@example.com', password: 'password', role: 'admin')

# Create regular users
user1 = User.create(first_name: 'User', last_name: '1', email: 'user1@example.com', password: 'password', role: 'user')
user2 = User.create(first_name: 'User', last_name: '2', email: 'user2@example.com', password: 'password', role: 'user')
user3 = User.create(first_name: 'User', last_name: '3', email: 'user3@example.com', password: 'password', role: 'user')

# Create categories for computer accessories
categories = Category.create([
  { name: 'Keyboards' },
  { name: 'Mice' },
  { name: 'Monitors' },
  { name: 'Cables' },
  { name: 'Headsets' }
])

# Generate 20 products and associate them with categories
20.times do
  product = Product.create(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    price: Faker::Commerce.price(range: 10.0..500.0, as_string: false),
    barcode: Faker::Barcode.ean
  )

  # Associate the product with a random category
  product.categories << categories.sample

  # Create ProductInventory for the product
  product_inventory = ProductInventory.create(
    product: product,
    stock_quantity: 100,
    restock_alert_threshold: 20
  )
end
