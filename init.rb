# Include hook code here
require 'rails_cache_wurfl'
ApplicationController.send(:include, RailsCacheWurfl)
ActionView::Base.send(:include, RailsCacheWurfl::View)
RailsCacheWurfl.init