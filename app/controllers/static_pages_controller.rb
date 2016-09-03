class StaticPagesController < ApplicationController
  def about
  end

  def help
  end
  
  def home
    if !logged_in?
      redirect_to login_path
    else
      @instances = BearsInstance.all.map {|i| i.capacity_data }
    end
  end
  
  def news
  end
end
