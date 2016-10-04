# == Schema Information
#
# Table name: admin_credentials
#
#  id                    :integer          not null, primary key
#  account               :string
#  encrypted_password    :string
#  encrypted_password_iv :string
#  description           :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_admin_credentials_on_description  (description) UNIQUE
#

require 'test_helper'

module Admin
  class CredentialTest < ActiveSupport::TestCase
    def setup
      @cred = Credential.new(account: "admin", description: "SAN switch account",
                       password: "password", password_confirmation: "password")
      @local_cred = admin_credentials(:bears_local)
    end
    
     test "should be valid" do
      assert @cred.valid?
    end
    
    test "account should be present" do
      @cred.account = "     "
      assert_not @cred.valid?
    end
    
    test "description should be present" do
      @cred.description = "     "
      assert_not @cred.valid?
    end
    
    test "description should be unique" do
      duplicate_cred = @cred.dup
      @cred.save
      assert_not duplicate_cred.valid?
    end
    
    test "password should be present (nonblank)" do
      @cred.password = @cred.password_confirmation = " " * 6
      assert_not @cred.valid?
    end
    
    test "password can be nil" do
      @cred.password = @cred.password_confirmation = nil
      assert @cred.valid?
    end
    
    test "password should be confirmed" do
      @cred.password_confirmation = " " * 6
      assert_not @cred.valid?
    end
    
    test "password can be decrypted" do
      @cred.save
      assert_equal "password", @cred.password
    end
    
    test "should not delete credential if used in resource" do
      assert_no_difference 'Credential.count' do
        @local_cred.destroy
      end
    end
  end
end
