# == Schema Information
#
# Table name: resource_storage_arrays
#
#  id            :integer          not null, primary key
#  instance_id   :integer
#  instance_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_resource_storage_arrays_on_instance_id_and_instance_type  (instance_id,instance_type)
#

# this require is required to fix weird lazy loading of namespaces/modules. 
# i.e if module Resource::Storage is defined elsewhere (test,controllers) and 
# loaded first, lazy loading will not load the resource/storage module
require_relative '../storage.rb'
module Resource::Storage
  class Array < ApplicationRecord
    belongs_to :instance, polymorphic:true
    
    # Array API - every array type needs to implement these
    
    def name
      instance.name
    end
    
    def serial
      instance.serial
    end
    
    def model
      instance.model
    end
    
    def firmware
      instance.firmware
    end
    
    def space_total
      instance.space_total
    end
    
    def space_used
      instance.space_used
    end
    
    def space_available
      instance.space_available
    end
  end
end
