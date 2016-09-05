module Resource::Storage
  class ArraysController < ApplicationController
    before_action :logged_in_user
    
    def index
      @arrays = Resource::Storage::Array.all
    end
  end
end
