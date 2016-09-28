class BearsInstancesController < ApplicationController
    before_action :logged_in_user
    
    def index
      respond_to do |format|
          format.html {
            redirect_to root_url
          }
          format.json {
            @bears_instances = BearsInstance.all 
            render json: @bears_instances
          }
      end
    end
end