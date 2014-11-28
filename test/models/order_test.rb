require 'test_helper'

class OrderTest < ActiveSupport::TestCase

	fixtures :orders

  	test "order attributes but ship_date must not be empty" do
		order = Order.new
		assert order.invalid?
		assert order.errors[:name].any?
		assert order.errors[:address].any?
		assert order.errors[:email].any?
		assert order.errors[:pay_type].any?
	end

end