module RailsCacheWurfl
  module View
    
    def handset
      RailsCacheWurfl.get_handset(session[:handset_agent])
    end
    
    def handset_capability(capability)
      return nil if handset.nil?
      handset.capability(capability)
    end

  end
end