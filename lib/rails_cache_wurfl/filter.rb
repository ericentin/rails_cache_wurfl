module RailsCacheWurfl
  module Filter
    
    def set_wurfl
    return unless session[:handset_checked].nil?
    session[:handset_agent] = RailsCacheWurfl.get_handset(request.headers['HTTP_USER_AGENT']).user_agent
    session[:handset_checked] = true
    end
    
  end
end