class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user_or_admin, only: [:edit, :update]
  before_action :admin_user,:not_same_user, only: [:destroy]
  
  before_action only: [:new,:create], if: -> { logged_in? } do |controller|
    redirect_to root_url
  end
  
  def index
    @users=User.all
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
      flash[:success] = "Profile updated"
      # admin updates should be redirected to users unless admin updates himself
      if current_user.admin? && current_user.id != @user.id
        # user updates should be redirected to profile 
        redirect_to users_path
      else
        redirect_to @user
      end
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :login, :password, :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger]="Please log in"
        redirect_to login_url
      end
    end
    
    # Confirms the correct user.
    def correct_user_or_admin
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    # Confirms it is not the same user
    def not_same_user
      redirect_to(root_url) if current_user? User.find(params[:id])
    end
end
