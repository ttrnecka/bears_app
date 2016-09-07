# == Schema Information
#
# Table name: data_centers
#
#  id                :integer          not null, primary key
#  name              :string
#  dc_code           :string(8)
#  bears_instance_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_data_centers_on_dc_code  (dc_code) UNIQUE
#

class DataCenter < ApplicationRecord
  validates :dc_code, uniqueness: true 
  
  has_many :arrays, class_name: "Resource::Storage::Array"
  belongs_to :bears_instance
  
  def space_total
    arrays.inject(0) {|sum,x| sum+x.space_total}
  end
  
  def space_used
    arrays.inject(0) {|sum,x| sum+x.space_used}
  end
  
  def space_available
    arrays.inject(0) {|sum,x| sum+x.space_available}
  end
end
