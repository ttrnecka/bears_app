module Admin
  class ResourcesController < ApplicationController
    before_action :logged_in_user
    before_action :admin_user
    
    def index
      respond_to do |format|
          format.html
          format.json {
            @resources = Admin::Resource.all 
            render json: @resources
          }
      end
    end
    
    def update
      @resource = Admin::Resource.find(params[:id])
      permitted = params.permit(:address, :protocol,:credential_id,:bears_instance_id).except(:resource)
      if @resource.update_attributes(permitted)
        render json: @resource
      else
        render json: { errors: @resource.errors.full_messages }, status: 422
      end
    end
    
    def create
      permitted = params.permit(:address, :protocol,:credential_id,:bears_instance_id).except(:resource)
      @resource = Admin::Resource.new(permitted)
      if @resource.save
        render json: @resource
      else
        render json: { errors: @resource.errors.full_messages }, status: 422
      end
    end
    
    def destroy
      resource = Admin::Resource.find(params[:id]).destroy
      head :no_content
    end
  end
end
