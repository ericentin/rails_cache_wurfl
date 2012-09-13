$:.unshift File.dirname(__FILE__)
require 'rails_cache_wurfl/cache_initializer'
require 'rails_cache_wurfl/view'
require 'rails_cache_wurfl/filter'
require 'rails_cache_wurfl/wurfl/wurfl_pointer'
require 'benchmark'

MEMCACHEDB_ADDRESS ||= '127.0.0.1:11311'

module RailsCacheWurfl
  attr_accessor :cache
  def self.cache
    @cache
  end
  
  def self.init
    return nil if Rails.env == 'test'
    # @cache = ActiveSupport::Cache.lookup_store(:mem_cache_store, MEMCACHEDB_ADDRESS)
    @cache = ActiveSupport::Cache.lookup_store :redis_store
    #@cache.logger = Rails.logger
    # determine if the cache has been initialized with the wurfl
    CacheInitializer.initialize_cache if RailsCacheWurfl.cache.read('wurfl_initialized').nil?
  end
  
  def self.get_handset(user_agent)
    return nil if user_agent.nil?
    handset = nil
    measure = Benchmark.measure do
      CacheInitializer.cache_initialized?
    
      user_agent.slice!(250..-1)
      user_agent = user_agent.tr(' ', '')

      handset = optimized_get_handset(user_agent)
    end
    Rails.logger.info("[WURFL-LOOKUP]" + measure.to_s)
    handset
  end
  
  def self.optimized_get_handset(user_agent)
    handset = @cache.read(user_agent)
    
    if(handset.is_a?(WurflPointer))
      handset = @cache.read(handset)
      # TODO: Store the optimized lookup for future lookups
    end
    
    return handset.dup unless handset.nil? 
    
    chopped_user_agent = user_agent.chop
    
    return nil if chopped_user_agent.empty?
    return self.optimized_get_handset(chopped_user_agent)
  end
end
