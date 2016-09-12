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

require_relative '../admin.rb'
module Admin
  class Credential < ApplicationRecord
    attr_encrypted :password, key: "\xDDw\xB4V\xEDJSoA\xDCV\x8D\xDD\xDC\xA7b\xB9A;\xDF\xC8\xC48u\xC4V\xAF\xF3x&\x9Ev", encode: true
    attr_accessor :password_confirmation
    
    validates :account, presence:true
    validates :description, presence:true, uniqueness: true
    validates :password, presence: true, confirmation:true, allow_nil: true
  end
end
