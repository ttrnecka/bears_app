# this require is required to fix weird lazy loading of namespaces/modules. 
# i.e if module Resource::Storage is defined elsewhere (test,controllers) and 
# loaded first, lazy loading will not load the resource/storage module
require_relative '../storage.rb'
module Resource::Storage
  class Array < ApplicationRecord
    belongs_to :instance, polymorphic:true
  end
end
