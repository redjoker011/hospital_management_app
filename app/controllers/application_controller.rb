class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :set_cache_buster

  #internationation setting for locale
  def default_url_options(options = {})
    options.merge!({ :locale => I18n.locale })
  end

  #Method to clear cache, so that once user has logged out and hits back button,
  #he will be prompted for login credentials.
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
