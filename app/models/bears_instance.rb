class BearsInstance < ApplicationRecord
   validates :name, uniqueness: true
   
   has_many :data_centers
end
