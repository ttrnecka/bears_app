require_relative '../storage.rb'

module Resource::Storage
  class Array < ApplicationRecord
    belongs_to :array, polymorphic:true
  end
end
