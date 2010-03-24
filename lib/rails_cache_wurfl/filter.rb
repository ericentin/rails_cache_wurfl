module RailsCacheWurfl
  module Filter
    
    def self.included(base) 
      base.extend ActMethods
    end 
    
    module ActMethods 
      def acts_as_mobile(opts={})
        $force = opts.has_key?(:force) ? opts.delete(:force) : false
        unless included_modules.include? InstanceMethods 
          extend ClassMethods
          prepend_before_filter :set_mobile_format, :handset
          helper_method :handset
          include InstanceMethods
        end 
      end 
    end

    module ClassMethods
      attr_accessor :xhtml_support_level
    end
    
    module InstanceMethods            
      def handset
        Rails.logger.debug "LOADING FOR #{request.headers['HTTP_USER_AGENT']}"
        @handset ||= RailsCacheWurfl.get_handset(request.headers['HTTP_USER_AGENT'])
        # TODO: Revise whether we want to rather cache handset in session. 
        # Suspect the memcache solution might be quicker than mysql based session. Need to bench
      end
      
      protected
        # This no longer sets the request format but instead just give the opportunity to override
        # layouts, templates or partials for specific device capabilities
      def set_mobile_format
        if @handset.user_agent =~ /(iPhone|Android)/ || ($force == :html5)
          format, @xhtml_support_level = :html5, @handset.xhtml_support_level
          prepend_custom_format_view_path(:html5) 
        elsif @handset && @handset.is_wireless_device? && request.format != :js
          format, @xhtml_support_level = :mobile,  @handset.xhtml_support_level 
          prepend_mobile_format_view_path(format, @xhtml_support_level)
        end
      end
      
      def prepend_mobile_format_view_path(format, level)
        self.prepend_view_path "app/views_custom/#{format.to_s}"
        case level
          when :high 
            self.prepend_view_path "app/views_custom/#{format.to_s}/low"
            self.prepend_view_path "app/views_custom/#{format.to_s}/mid"
            self.prepend_view_path "app/views_custom/#{format.to_s}/high"
          when :mid
            self.prepend_view_path "app/views_custom/#{format.to_s}/low"
            self.prepend_view_path "app/views_custom/#{format.to_s}/mid"
          when :low
            self.prepend_view_path "app/views_custom/#{format.to_s}/low"
        end
      end
      
      def prepend_custom_format_view_path(format)
        self.prepend_view_path "app/views_custom/#{format.to_s}"
      end
    end
  end
end