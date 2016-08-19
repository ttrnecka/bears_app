class StaticPagesController < ApplicationController
  def about
  end

  def help
  end
  
  def home
    redirect_to login_path if !logged_in?
  end
  
  def contact
  end
  
  def news
  end
end
