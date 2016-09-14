class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  after_action :set_csrf_cookie_for_ng
  
  LOG_DIR = Rails.root.to_s + '/log'
  
  private 
    def set_csrf_cookie_for_ng
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end
  
    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
    end
end
