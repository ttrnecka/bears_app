require 'test_helper'

class AdauthTest < ActionDispatch::IntegrationTest
    
  test "Adauth log file" do
    assert_equal File.join(Rails.root,"log","adauth.log"), ADAUTH_LOG.filename
  end
end

