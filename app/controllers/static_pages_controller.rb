class StaticPagesController < ApplicationController
  def about
  end

  def help
  end
  
  def home
    if !logged_in?
      redirect_to login_path
    else
      @graph_data = {}
      @graph_data[:instances] =  BearsInstance.all.map {|i| i.capacity_data }
      @graph_data[:arrays] =  Resource::Storage::Array.all.map {|a| a.capacity_data }
    end
  end
  
  def news
  end
end
