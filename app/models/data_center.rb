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