class DataCenter < ApplicationRecord
  validates :dc_code, uniqueness: true

  belongs_to :bears_instance
  
  # testing graphs
  def capacity_raw
    Random.rand(1000)
  end
end
