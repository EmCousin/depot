class ApplicationController < ActionController::Base
	before_action :set_i18n_locale_from_params
	include ActionView::Helpers::TextHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize

	helper_method:date_loaded
	def date_loaded
		return Time.now
	end

	protected

		def authorize 
			if User.count.zero?
				redirect_to new_user_url, notice: "Please create an admin account to continue"
			else
				if request.format == Mime::HTML
					user = User.find_by(id: session[:user_id])
				else
					user = authenticate_or_request_with_http_basic do |username, password|
							User.find_by_name(username).try(:authenticate, password)
					end
				end
				redirect_to login_url, notice: "Please log in" unless user
			end
		end

		def set_i18n_locale_from_params
			if params[:locale]
				if I18n.available_locales.map(&:to_s).include?(params[:locale])
					I18n.locale = params[:locale]
				else
					flash.now[:notice] = "#{params[:locale]} translation not available"
					logger.error flash.now[:notice]
				end
			end
		end

		def default_url_options
			{ locale: I18n.locale }
		end
end
