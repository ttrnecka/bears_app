class SessionsController < ApplicationController
  before_action only: [:new], if: -> { logged_in? } do |controller|
    redirect_to root_url
  end
  
  def new
  end
  
  def create
    begin
      @user = User.authenticate(params[:session][:login],params[:session][:password])
    rescue Net::LDAP::Error => e
      logger.fatal e
      logger.fatal e.backtrace
      flash[:danger] = "There are problems with AD authentication, see logs for more details"
      redirect_to login_url and return
    end
    if @user
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or root_path
    else
      flash.now[:danger] = 'Invalid login/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
