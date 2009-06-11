module RailsCacheWurfl
  module Filter
    
    def set_wurfl
      return unless session[:handset_checked].nil?
      handset = RailsCacheWurfl.get_handset(request.headers['HTTP_USER_AGENT'])
      session[:handset_agent] = handset.user_agent unless handset.nil?
      session[:handset_checked] = true
    end
    
  end
end