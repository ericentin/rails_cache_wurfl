module RailsCacheWurfl
  module View
    
    def handset_capability(capability)
      return nil if handset.nil?
      capability = handset[capability]
      return nil if capability.nil?
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