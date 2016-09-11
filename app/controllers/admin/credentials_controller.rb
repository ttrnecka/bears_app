module Admin
  class CredentialsController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
    before_action :admin_user, only: [:index, :destroy]
    
    def index
      respond_to do |format|
          format.html
          format.json {
            @credentials = Credential.all 
            render json: @credentials
          }
      end
    end
  end
end
