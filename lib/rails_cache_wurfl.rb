require 'rails_cache_wurfl/wurfl_load'
require 'rails_cache_wurfl/cache_initializer'
require 'rails_cache_wurfl/view'

module RailsCacheWurfl
  def self.init
    # determine if the cache has been initialized with the wurfl
    initialize_cache if Rails.cache.read('wurfl_initialized').nil?
    # add the helper to the app's load paths
    path = File.join(File.dirname(__FILE__), 'app', 'helpers')
    $LOAD_PATH << path
    ActiveSupport::Dependencies.load_paths << path
    ApplicationController.before_filter :check_wurfl_filter
    Rails.cache.silence!
  end
  
  def self.get_phone(user_agent)
    cache_initialized?
    user_agent.slice!(250..-1)
    phone = Rails.cache.read(user_agent.tr(' ', ''))
    chopped_user_agent = user_agent.chop
    return nil, '' if chopped_user_agent.empty?
    return self.get_phone(chopped_user_agent) if phone.nil?
    return phone
  end
  
  def check_wurfl_filter
    return unless session[:phone_checked].nil?
    session[:phone_agent] = RailsCacheWurfl.get_phone(request.headers['HTTP_USER_AGENT']).user_agent
    session[:phone_checked] = true
  end
end
