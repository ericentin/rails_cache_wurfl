module RailsCacheWurfl
  module View
    
    def handset
      @handset ||= RailsCacheWurfl.get_handset(session[:handset_agent])
    end
    
    def handset_capability(capability)
      return nil if handset.nil?
      handset.capability(capability)
    end
    
    def specify_width_if_mobile
      if handset.is_wireless_device?
         " style='width:#{(handset_capability(:resolution_width)) ? handset_capability(:resolution_width) : "240"}px;'"
       elsif session[:force_agent] == :mobile
         " style='width:240px;'"
       end
    end

  end
end