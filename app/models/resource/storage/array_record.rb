# Array API - every array type needs to implement these
# attribute name -> (string)
# attribute serial -> (string)
# attribute model -> (string)
# attribute firmware -> (string)
# attribute space_total -> (integer) in GB
# attribute space_available -> (integer) in GB
# attribute space_used -> (integer) in GB
# method family_name -> (string) - array class name (3PAR, EVA)
# relation belongs_to data_center -> (DataCenter)

# inherits relation has_one abstract array pointong to global array table
    
module Resource::Storage
  class ArrayRecord < ActiveRecord::Base
    self.abstract_class = true
    
    validates :name, presence: true
    validates :model, presence: true
    validates :serial, presence: true, uniqueness: true
    validates :firmware, presence: true
    validates :space_total, presence: true
    validates :space_available, presence: true
    validates :space_used, presence: true
    validates :data_center, presence: true
    
    has_one :abstract_array, as: :instance, class_name: "Resource::Storage::Array"
    belongs_to :data_center
    
    after_create do 
      self.create_abstract_array(data_center:data_center)
    end
    
  end
end
