class BearsInstance < ApplicationRecord
   validates :name, uniqueness: true
   
   has_many :data_centers
   
   def capacity_data
     {
       label: name,
       data: data_centers.inject(0) {|sum,x| sum+x.capacity_raw }
     }
   end
end
