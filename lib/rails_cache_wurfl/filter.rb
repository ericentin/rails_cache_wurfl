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
        @handset ||= RailsCacheWurfl.get_handset(request.headers['HTTP_USER_AGENT'])
        check_override
        @handset
        # TODO: Revise whether we want to rather cache handset in session. 
        # Suspect the memcache solution might be quicker than mysql based session. Need to bench
      end
      
      protected
      def check_override
        @handset.xhtml_support_level = request.params[:ol] if request.params[:ol] #Debugging
      end
        # This no longer sets the request format but instead just give the opportunity to override
        # layouts, templates or partials for specific device capabilities
      def set_mobile_format
        if @handset.user_agent =~ /(iPhone|Android)/ || ($force == :html5)
          format, @xhtml_support_level = :html5, @handset.xhtml_support_level
          prepend_mobile_format_view_path(@xhtml_support_level)
          prepend_custom_format_view_path(:html5) 
        elsif @handset && @handset.is_wireless_device? && request.format != :js
          format, @xhtml_support_level = :mobile,  @handset.xhtml_support_level 
          prepend_mobile_format_view_path(@xhtml_support_level)
        end
      end
      
      def prepend_mobile_format_view_path(level)
        case level
          when :high 
            self.prepend_view_path "app/views_custom/mobile_base"
            self.prepend_view_path "app/views_custom/mobile_mid"
            self.prepend_view_path "app/views_custom/mobile_high"
          when :mid_high
            self.prepend_view_path "app/views_custom/mobile_base"
            self.prepend_view_path "app/views_custom/mobile_mid"
            self.prepend_view_path "app/views_custom/mobile_mid_high"
          when :mid
            self.prepend_view_path "app/views_custom/mobile_base"
            self.prepend_view_path "app/views_custom/mobile_mid"
          when :low
            self.prepend_view_path "app/views_custom/mobile_base"
        end
      end
      
      def prepend_custom_format_view_path(format)
        self.prepend_view_path "app/views_custom/#{format.to_s}"
      end
    end
  end
end