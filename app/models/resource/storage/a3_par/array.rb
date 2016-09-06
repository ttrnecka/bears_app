# == Schema Information
#
# Table name: resource_storage_a3_par_arrays
#
#  id              :integer          not null, primary key
#  name            :string
#  model           :string
#  serial          :string
#  firmware        :string
#  space_total     :integer
#  space_available :integer
#  space_used      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_resource_storage_a3_par_arrays_on_name    (name)
#  index_resource_storage_a3_par_arrays_on_serial  (serial) UNIQUE
#

# this require is required to fix weird lazy loading of namespaces/modules. 
# i.e if module Resource::Storage is defined elsewhere (test,controllers) and 
# loaded first, lazy loading will not load the resource/storage module
require_relative '../a3_par.rb'
module Resource::Storage::A3Par
  class Array < ApplicationRecord
    validates :name, presence: true
    validates :model, presence: true
    validates :serial, presence: true, uniqueness: true
    validates :firmware, presence: true
    validates :space_total, presence: true
    validates :space_available, presence: true
    validates :space_used, presence: true
    
    has_one :abstract_array, as: :instance, class_name: "Resource::Storage::Array"
    
    after_create do 
      self.create_abstract_array
    end
  end
end
