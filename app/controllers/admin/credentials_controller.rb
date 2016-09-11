module Admin
  class CredentialsController < ApplicationController
    before_action :logged_in_user
    before_action :admin_user
    
    def index
      respond_to do |format|
          format.html
          format.json {
            @credentials = Credential.all 
            render json: @credentials
          }
      end
    end
    
    def destroy
      credential = Credential.find(params[:id]).destroy
      #flash[:success] = "User #{user.login} deleted"
      respond_to do |format|
        format.html {redirect_to admin_credentials_path }
        format.json { head :no_content }
      end
    end
  end
end
