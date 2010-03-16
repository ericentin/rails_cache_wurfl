module RailsCacheWurfl
  module Filter
    
    def self.included(base) 
      base.extend ActMethods
    end 
    
    module ActMethods 
      def acts_as_mobile(opts={})
        $force_mobile = opts.has_key?(:force_mobile) ? opts.delete(:force_mobile) : false
        unless included_modules.include? InstanceMethods 
          extend ClassMethods
          prepend_before_filter :set_mobile_format, :handset
          helper_method :handset
          include InstanceMethods
        end 
      end 
    end

    module ClassMethods
    end
    
    module InstanceMethods            
      def handset
        @handset ||= RailsCacheWurfl.get_handset(request.headers['HTTP_USER_AGENT'])
        # TODO: Revise whether we want to rather cache handset in session. 
        # Suspect the memcache solution might be quicker than mysql based session. Need to bench
      end
      
      protected
      def set_mobile_format
        request.format = :mobile if @handset && @handset.is_wireless_device? && request.format != :js
        Rails.logger.debug "Request Format #{request.format}"
      end
    end
  end
end