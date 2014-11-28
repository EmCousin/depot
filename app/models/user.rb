class User < ActiveRecord::Base
	after_destroy :ensures_an_admin_remains
	validates :name, presence: true, uniqueness: true
  	has_secure_password
  	# The has_secure_password() method tells Rails to validate that the paswword has to match in 2 fields
  	# Thanks to the password:digest when we generated the scaffold

  	private
  		def ensures_an_admin_remains
  			raise "Can't delete that user" if User.count.zero?
  			# The exception is raised during a transaction, therefore it causes an automatic rollback
  			# It means we undo the delete and restore the last user
  			# The exception signals the error back to the controller, where we use a begin/end block
  			# to handle it and report the error to the user in the flash
  		end

end
