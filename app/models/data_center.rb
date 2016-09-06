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

  belongs_to :bears_instance
  
  # testing graphs
  def capacity_raw
    @capacity_raw ||= Random.rand(1000)
  end
  
  def capacity_raw_free
    @capacity_raw_free ||= Random.rand(capacity_raw)
  end
  
  def capacity_raw_used
    capacity_raw - capacity_raw_free
  end
end
