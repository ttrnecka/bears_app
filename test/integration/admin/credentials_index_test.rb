require 'test_helper'

class Admin::CredentialsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:admin)
  end
  
  test "index" do
    log_in_as @admin
    get admin_credentials_path
    assert_template "admin/credentials/index"
    Admin::Credential.all.each do |cred|
      #assert_select 'a[href=?]', admin_credential_path(cred), text: cred.description
    end
    assert_select 'table[datatable="ng"]', count:1
    assert_select 'table#credentials_table', count:1
  end
end
