require 'rails_cache_wurfl/wurfl_load'
def load_wurfl
  wurfl_loader = WurflLoader.new
  return wurfl_loader.load_wurfl(Rails.root.join('tmp/wurfl/wurfl.xml'))
end

def cache_initialized?
  return true if Rails.cache.read('wurfl_initialized')
  initialize_cache
  loop do
    break if Rails.cache.read('wurfl_initialized') 
    sleep(0.1)
  end
  return true
end

def initialize_cache
  # Prevent more than one process from trying to initialize the cache.
  return unless Rails.cache.write('wurfl_initializing', true, :unless_exist => true)
  
  Rails.cache.write('wurfl_initialized', false)
  # Proceed to initialize the cache.
  handsets, fallbacks = load_wurfl
  handsets.each_value do |handset|
    Rails.cache.write(handset.user_agent.tr(' ', ''), handset)
  end
  Rails.cache.write('wurfl_initialized', true)
  Rails.cache.write('wurfl_initializing', false)
end

