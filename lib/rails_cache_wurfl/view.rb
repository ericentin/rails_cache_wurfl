module RailsCacheWurfl
  module View

    def handset
      RailsCacheWurfl.get_handset(session[:handset_agent])
    end
    
    def handset_capability(capability)
      capability = handset[capability]
      case capability.strip
      when /^d+$/
        capability = capability.to_i
      when /^true$/i
        capability = true
      when /^false$/i
        capability = false
      end
      return capability
    end

  end
end