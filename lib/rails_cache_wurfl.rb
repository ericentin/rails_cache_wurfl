require 'rails_cache_wurfl/cache_initializer'
require 'rails_cache_wurfl/view'
require 'rails_cache_wurfl/filter'

MEMCACHEDB_ADDRESS ||= '127.0.0.1:11311'

module RailsCacheWurfl
  attr_accessor :cache
  def self.cache
    @cache
  end
  
  def self.init
    return nil if Rails.env == 'test'
    @cache = ActiveSupport::Cache.lookup_store(:mem_cache_store, MEMCACHEDB_ADDRESS)
    @cache.logger = Rails.logger
    # determine if the cache has been initialized with the wurfl
    CacheInitializer.initialize_cache if RailsCacheWurfl.cache.read('wurfl_initialized').nil?
  end
  
  def self.get_handset(user_agent)
    return nil if user_agent.nil?
    CacheInitializer.cache_initialized?
    user_agent.slice!(250..-1)
    handset = @cache.read(user_agent.tr(' ', ''))
    chopped_user_agent = user_agent.chop
    return nil if chopped_user_agent.empty?
    return self.get_handset(chopped_user_agent) if handset.nil?
    return handset.dup
  end
end
