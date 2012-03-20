class ApplicationController < ActionController::Base
  protect_from_forgery
  RELOAD_LIBS = []
  RELOAD_LIBS.concat( Dir[Rails.root + 'lib/**/common/*.rb'] ) if Rails.env.development?
  RELOAD_LIBS.concat( Dir[Rails.root + 'lib/**/db/*.rb'] ) if Rails.env.development?
  RELOAD_LIBS.concat( Dir[Rails.root + 'lib/**/indicator/*.rb'] ) if Rails.env.development?
  before_filter :_reload_libs, :if => :_reload_libs?

  def _reload_libs
    puts "call _reload_libs"
    RELOAD_LIBS.each do |lib|
      require_dependency lib
    end
  end

  def _reload_libs?

    defined? RELOAD_LIBS
  end
end
