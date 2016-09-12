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
    
    def update
      @credential = Credential.find(params[:id])
      permitted = params.require(:admin_credential).permit(:description, :account,:password,:password_confirmation)
      if @credential.update_attributes(permitted)
        render json: @credential
      else
        render json: { errors: @credential.errors.full_messages }, status: 422
      end
    end
    
    def destroy
      credential = Credential.find(params[:id]).destroy
      head :no_content
    end
  end
end
