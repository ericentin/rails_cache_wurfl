require 'rails_cache_wurfl/wurfl_load'
require 'rails_cache_wurfl/cache_initializer'

module RailsCacheWurfl
  def self.init
    # determine if the cache has been initialized with the wurfl
    puts 'init'
    initialize_cache if Rails.cache.read('wurfl_initialized').nil?

    # add the helper to the app's load paths
    path = File.join(File.dirname(__FILE__), 'app', 'helpers')
    $LOAD_PATH << path
    ActiveSupport::Dependencies.load_paths << path
    ActiveSupport::Dependencies.load_once_paths.delete(path)
  end
  
  def self.get_phone(user_agent)
    phone = Rails.cache.read('user_agent'.tr(' ', ''))
  end
end
