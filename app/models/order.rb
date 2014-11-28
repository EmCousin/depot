class Order < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	has_many :payment_types
	validates :name, :address, :email, presence: true
 	validates_each :pay_type do |model, attr, value|
 		model.errors.add(attr, "Payment type not available") unless PaymentType.names.include?(value)
 	end
	# VALIDATION RULES -> FIXTURES

	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil
			line_items << item
		end
	end

end
