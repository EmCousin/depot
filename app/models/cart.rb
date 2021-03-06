class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy

	def add_product(product_id)
		@product = Product.find(product_id)
		current_item = line_items.where(product_id: @product.id).first
		if current_item
			current_item.quantity += 1
		else
			current_item = line_items.build(product_id: @product.id)
			current_item.price = current_item.product.price
			line_items << current_item
		end
		current_item
	end

	def remove_product(product_id)
		@product = Product.find(product_id)
		current_item = line_items.where(product_id: @product.id).first
		if current_item
			if current_item.quantity > 1
				current_item.quantity -= 1
			else
				current_item.destroy
			end
		end
		current_item
	end

	def total_price
		line_items.to_a.sum do |item| item.total_price end
	end

end
