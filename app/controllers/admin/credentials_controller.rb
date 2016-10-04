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
      # niling blank password to allow updates without passwords (edit modal will have by default blank and not null values)
      params[:password]=nil if params[:password].blank?
      params[:password_confirmation]=nil if params[:password_confirmation].blank?
      @credential = Credential.find(params[:id])
      permitted = params.permit(:description, :account,:password,:password_confirmation).except(:credential)
      if @credential.update_attributes(permitted)
        render json: @credential
      else
        render json: { errors: @credential.errors.full_messages }, status: 422
      end
    end
    
    def create
      # setting password to blank if nil to prevent creation fo user withput password
      # allow nil is required for user update
      params[:password]||=""
      params[:password_confirmation]||=""
      permitted = params.permit(:description, :account,:password,:password_confirmation).except(:credential)
      @credential = Credential.new(permitted)
      if @credential.save
        render json: @credential
      else
        render json: { errors: @credential.errors.full_messages }, status: 422
      end
    end
    
    def destroy
      credential = Credential.find(params[:id])
      if credential.destroy
        head :no_content
      else
        render json: { errors: credential.errors.full_messages }, status: 422
      end
    end
    
    def search
      if params[:description]
        @found = Credential.where(description: params[:description])
      end
      render json: @found
    end
  end
end
