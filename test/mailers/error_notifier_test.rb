require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "occured" do
    mail = ErrorNotifier.occured("Cart invalid")
    assert_equal "Error Incident Notification", mail.subject
    assert_equal ["emmanuel_cousin@hotmail.fr"], mail.to
    assert_equal ["admin@depot.com"], mail.from
    assert_match "Cart invalid", mail.body.encoded
  end
end