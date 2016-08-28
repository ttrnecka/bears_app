class StorageArray < ApplicationRecord
  belongs_to :array, polymorphic:true 
end
