require 'rails_cache_wurfl/wurfl_load'
def load_wurfl
  wurfl_loader = WurflLoader.new
  return wurfl_loader.load_wurfl(Rails.root.join('tmp/wurfl/wurfl.xml'))
end

def initialize_cache
  # Prevent more than one process from trying to initialize the cache.
  return unless Rails.cache.write('wurfl_initialized', true, :unless_exist => true)
  puts 'should only see this once'
  # Proceed to initialize the cache.
  handsets, fallbacks = load_wurfl
end