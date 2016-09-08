# == Schema Information
#
# Table name: resource_storage_eva_arrays
#
#  id              :integer          not null, primary key
#  name            :string
#  model           :string
#  serial          :string
#  firmware        :string
#  space_total     :integer
#  space_available :integer
#  space_used      :integer
#  data_center_id  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_resource_storage_eva_arrays_on_data_center_id  (data_center_id)
#  index_resource_storage_eva_arrays_on_name            (name)
#  index_resource_storage_eva_arrays_on_serial          (serial) UNIQUE
#

require_relative '../eva.rb'
module Resource::Storage::Eva
  class Array < Resource::Storage::ArrayRecord
    
    # API
    def family_name
      "EVA"
    end
  end
end