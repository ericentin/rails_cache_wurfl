require 'rails_cache_wurfl/cache_initializer'
require 'rails_cache_wurfl/view'
require 'rails_cache_wurfl/filter'

module RailsCacheWurfl
  def self.init
    # determine if the cache has been initialized with the wurfl
    initialize_cache if Rails.cache.read('wurfl_initialized').nil?
    #ApplicationController.before_filter :check_wurfl_filter
  end
  
  def self.get_handset(user_agent)
    return nil if user_agent.nil?
    cache_initialized?
    user_agent.slice!(250..-1)
    handset = Rails.cache.read(user_agent.tr(' ', ''))
    chopped_user_agent = user_agent.chop
    return nil if chopped_user_agent.empty?
    return self.get_handset(chopped_user_agent) if handset.nil?
    return handset
  end
end
