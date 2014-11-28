class PaymentType < ActiveRecord::Base
  belongs_to :order

	def self.names
		all.collect do |payment_type|
			payment_type.name
		end
	end

end
