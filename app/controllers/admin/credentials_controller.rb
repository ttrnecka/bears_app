module Admin
  class CredentialsController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
    before_action :admin_user, only: [:index, :destroy]
    
    def index
      @credentials = Credential.all
      respond_to do |format|
          format.html
          format.json { render json: @credentials}
      end
    end
  end
end
