class StorageArraysController < ApplicationController
  before_action :logged_in_user
  
  def index
    @storage_arrays = StorageArray.all
  end
end
