# == Schema Information
#
# Table name: bears_instances
#
#  id         :integer          not null, primary key
#  name       :string
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bears_instances_on_name  (name) UNIQUE
#

class BearsInstance < ApplicationRecord
   validates :name, uniqueness: true
   
   has_many :data_centers
   
   def capacity_data
     {
       label: name,
       data_total: data_centers.inject(0) {|sum,x| sum+x.space_total },
       data_available: data_centers.inject(0) {|sum,x| sum+x.space_available },
       data_used: data_centers.inject(0) {|sum,x| sum+x.space_used }
     }
   end
end
