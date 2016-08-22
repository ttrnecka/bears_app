class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  LOG_DIR = Rails.root.to_s + '/log'
end
