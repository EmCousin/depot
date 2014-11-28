require 'test_helper'

class ProductTest < ActiveSupport::TestCase

	fixtures :products

	test "product attributes must not be empty" do
	  product = Product.new
	  assert product.invalid?
	  assert product.errors[:title].any?
	  assert product.errors[:description].any?
	  assert product.errors[:price].any?
	  assert product.errors[:image_url].any?
	end

	test "product price must be positive" do
		product = Product.new(	title: "My Book Title",
								description: "yyy",
								image_url: "zzz.jpg")
		product.price = -1
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

		product.price = 0
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

		product.price = 1
		assert product.valid?
	end

	def new_product(image_url)
		Product.new(title: "My Book Title",
					description: "yyy",
					price: 1,
					image_url: image_url)
	end
	test "image_url" do
		ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
		bad = %w{ fred.doc fred.gif/more fred.gif/more }
		ok.each do |name|
			assert new_product(name).valid?, "#{name} should be valid"
		end
		bad.each do |name|
			assert new_product(name).invalid?, "#{name} shouldn't be valid"
		end
	end

	test "product is not valid without a unique title" do
		# products is a method defined by default from the products.yml file
		# convention over configuration for the win !
		# The test assumes that the database ALREADY includes a row for the Ruby book.
		# It gets the title of that existing row using this: products(:ruby).title
		# Because we used fixtures :products in which :ruby already exists
		product = Product.new(	
								title: products(:ruby).title,
								description: "yyy",
								price: 1,
								image_url: "fred.gif")
		assert product.invalid?
		assert_equal ["has already been taken"], product.errors[:title]
	end

	test "product title must be minimum 10 characters long" do
		product_title_long_enough = Product.new(
								title: "My Book Title",
								description: "yyy",
								price: 1,
								image_url: "fred.jpg")
		assert product_title_long_enough.valid?, "Product title is long enough (>= 10 characters)"
		product_title_too_short = Product.new(
								title: "My Book Title",
								description: "yyy",
								price: 1,
								image_url: "fred.jpg")
		assert product_title_too_short.valid?, "Product title is too short (<= 10 characters)"
	end

end
