require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
 	fixtures :products
 	fixtures :users

 	test "buying a product" do

	 	# Let's empty the LineItem and Order before we start as we want to add one of each by the end of the test
	 	LineItem.delete_all
	 	Order.delete_all
	 	ruby_book = products(:ruby)

	 	# Story 1 : A user goes to the store index page
	 	get "/"
	 	assert_response :success
	 	assert_template "index"

	 	# Story 2 : They select a product, adding it to their cart
	 	# It uses AJAX ! => We'll use the xml_http_request() method

	 	xml_http_request :post, 'line_items', product_id: ruby_book.id
	 	assert_response :success

	 	cart = Cart.find(session[:cart_id])
	 	assert_equal 1, cart.line_items.size
	 	assert_equal ruby_book, cart.line_items[0].product

	 	# Story 3 : Then they checkout...

	 	get "/orders/new"
	 	assert_response :success
	 	assert_template "new"

	 	# Story 4 : They fill the order form => we use the post_via_redirect() method
	 	# Then we ensure that we are redirected to the store page ("index")
	 	# Then we ensure that the Cart is empty after the order is completed

	 	ship_date_expected = Time.now.to_date

	 	post_via_redirect "/orders", order: {
	 											name: "Dave Thomas",
	 											address: "123 The Street",
	 											email: "dave@example.com",
	 											pay_type: "Check",
	 										}
	 	assert_response :success
	 	assert_template "index"
	 	cart = Cart.find(session[:cart_id])
	 	assert_equal 0, cart.line_items.size

	 	# Story 5 : We verify that the order is created and the details are correct

	 	orders = Order.all
	 	assert_equal 1, orders.size
	 	order = orders[0]
	 	order.ship_date = ship_date_expected

	 	assert_equal "Dave Thomas", order.name
	 	assert_equal "123 The Street", order.address
	 	assert_equal "dave@example.com", order.email
	 	assert_equal "Check", order.pay_type
	 	assert_equal ship_date_expected, order.ship_date.to_date

	 	assert_equal 1, order.line_items.size
	 	line_item = order.line_items[0]
	 	assert_equal ruby_book, line_item.product

	 	# Story 6 : The confirmation email is correctly addressed and has the expected subject line
	 	mail = ActionMailer::Base.deliveries.last
	 	assert_equal ["dave@example.com"], mail.to
	 	assert_equal 'depot@example.com', mail[:from].value
	 	assert_equal "Pragmatic Store Order Confirmation", mail.subject
	 end 

	# test "should mail the admin when an error occurs" do
	#
	# 	# The user tries to go to an non-existing cart
	# 	get "carts/wibble"
	# 	assert_response :redirect
	# 	assert_redirected_to store_path
	#
	# 	# We verify that the email containing the error is correct
	# 	mail = ActionMailer::Base.deliveries.last
	# 	assert_equal ["emmanuel_cousin@hotmail.fr"], mail.to
	# 	assert_equal 'admin@depot.com', mail[:from].value
	# 	assert_equal "Error Incident Notification", mail.subject
	# end

	test "should NOT access sensitive data without a login" do

		# LOGIN
		user = users(:one)
		get "/login"
		assert_response :success
		post_via_redirect "/login", name: user.name, password: 'secret'
		assert_response :success
		assert_equal '/admin', path

		# Access sensitive resource while logged in
		get 'carts/1'
		assert_response :success
		assert_equal '/carts/1', path

		# Logout
		delete '/logout'
		assert_response :redirect
		assert_redirected_to store_path

		# Try accessing sensitive resource while logged out
		get 'carts/1'
		assert_redirected_to login_path
	end

end