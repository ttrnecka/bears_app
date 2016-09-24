# == Schema Information
#
# Table name: admin_resources
#
#  id                :integer          not null, primary key
#  address           :string
#  protocol          :string
#  credential_id     :integer
#  bears_instance_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require_relative '../admin.rb'
module Admin
  class Resource < ApplicationRecord
    
    PROTOCOLS = ["http","https","ssh","sssu"]
    IP_REGEX = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
    FQDN_REGEX = /(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)/
    
    belongs_to :credential, class_name: "Admin::Credential"
    belongs_to :bears_instance
    
    validates :address, presence: true
    validates :protocol, presence: true
    validates :credential_id, presence:true
    
    validate :protocol_must_be_from_list
    validate :address_must_be_ip_or_fqdn
    
    
    private
    
    def protocol_must_be_from_list
      if !PROTOCOLS.include? protocol
        errors.add(:protocol, "must be from the list: #{PROTOCOLS.join(',')}")
      end
    end
    
    def address_must_be_ip_or_fqdn
      if !address.match(IP_REGEX) && !address.match(FQDN_REGEX)
        errors.add(:address, "must be IP or FQDN")
      end
    end
  end
end
