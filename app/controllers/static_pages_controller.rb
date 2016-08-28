class StaticPagesController < ApplicationController
  def about
  end

  def help
  end
  
  def home
    if !logged_in?
      redirect_to login_path
    else
      @instances = BearsInstance.all
    end
  end
  
  def news
  end
end
