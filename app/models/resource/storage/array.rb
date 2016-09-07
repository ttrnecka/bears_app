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
    # name -> (string)
    # serial -> (string)
    # model -> (string)
    # firmware -> (string)
    # space_total -> (integer) in GB
    # space_available -> (integer) in GB
    # space_used -> (integer) in GB
    # family_name -> (string) - array class name (3PAR, EVA)
    # data_center -> (DataCenter)
    delegate :name, :serial, :model, :firmware, :space_total, :space_used, :space_available, :family_name, :data_center, to: :instance
    
  end
end
