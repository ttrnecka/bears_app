class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user_or_admin, only: [:update]
  before_action :correct_user, only: [:edit]
  before_action :not_same_user, only: [:destroy]
  before_action :admin_user, only: [:index, :destroy]
  
  before_action only: [:new,:create], if: -> { logged_in? } do |controller|
    redirect_to root_url
  end
  
  def index 
    respond_to do |format|
      format.html
      format.json {
        @users=User.all 
        render json: @users
      }
    end
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success]="Welcome to #{BEARS['app_name']}!"
      redirect_to root_path    
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      # admin updates should be redirected to users unless admin updates himself
      respond_to do |format|
        format.html do 
          if current_user.admin? && current_user.id != @user.id
            flash[:success] = "User #{@user.login} updated"
            # user updates should be redirected to profile 
            redirect_to users_path
          else
            flash[:success] = "Profile updated"
            redirect_to @user
          end
        end
        format.json {render json: @user}
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.json { render({ errors: @user.errors.full_messages }, status: 422) }
      end
    end
  end
  
  def destroy
    user = User.find(params[:id]).destroy
    head :no_content
  end
  
  private
  
    def user_params
      # admin updating some else
      if current_user && current_user.admin? && current_user.id != params[:id].to_i
          params.require(:user).permit(:name, :email, :login, :roles)
      # users/admin updating/creating themselves
      else
        params.require(:user).permit(:name, :email, :login, :password, :password_confirmation)
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def correct_user_or_admin
      @user = User.find(params[:id])
      if request.format.json?
        render :json => [], :status => :unauthorized
      else
        redirect_to root_url
      end unless current_user?(@user) || current_user.admin?
    end
    
    # Confirms it is not the same user
    def not_same_user
      if request.format.json?
        render :json => [], :status => :unauthorized
      else
        redirect_to(root_url)
      end if current_user? User.find(params[:id])
    end
end
