module Resource::Storage
  class ArraysController < ApplicationController
    before_action :logged_in_user
    
    def index
      if params[:array_type]
        @arrays = Resource::Storage::Array.where(instance_type: "Resource::Storage::#{params[:array_type]}::Array")
      else
        @arrays = Resource::Storage::Array.all
      end
    end
  end
end
