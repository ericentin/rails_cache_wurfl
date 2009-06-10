require 'rails_cache_wurfl/wurfl_load'
require 'rails_cache_wurfl/cache_initializer'

module RailsCacheWurfl
  def self.init
    # determine if the cache has been initialized with the wurfl
    puts 'init'
    initialize_cache if Rails.cache.read('wurfl_initialized').nil?
    debugger
    # add the helper to the app's load paths
    path = File.join(File.dirname(__FILE__), 'app', 'helpers')
    $LOAD_PATH << path
    ActiveSupport::Dependencies.load_paths << path
    ActiveSupport::Dependencies.load_once_paths.delete(path)
  end
  
  def self.get_phone(user_agent)
    user_agent.slice!(250..-1)
    phone = Rails.cache.read(user_agent.tr(' ', ''))
    return nil if user_agent.chop!.nil?
    return self.get_phone(user_agent) if phone.nil?
    return phone
  end
end
