class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart

  def index
    if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
    	@products = Product.order(:title)
    	@counter_access_store_index = implement_counter_access_store_index
    	@display_counter_index = display_counter_index_if_greater_than_five
    end
  end

  private
  	def implement_counter_access_store_index
  		session[:counter] ||= 0
  		session[:counter] += 1
  	end

  	def display_counter_index_if_greater_than_five
  		@session_count_times = pluralize(session[:counter], 'time')
  		display_counter_index = session[:counter] > 5 ?
  		"You visited this page #{@session_count_times}." : ""
	end
end
