# Include hook code here
require 'rails_cache_wurfl'
ActionController::Base.send(:include, RailsCacheWurfl::Filter)
ActionView::Base.send(:include, RailsCacheWurfl::View)
RailsCacheWurfl.init