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
        @handset ||= (RailsCacheWurfl.get_handset(request.headers['HTTP_USER_AGENT']) || create_empty())
        # TODO: Revise whether we want to rather cache handset in session. 
        # Suspect the memcache solution might be quicker than mysql based session. Need to bench
      end
      
      protected
      def create_empty
        handset = WurflHandset.new(nil, request.headers['HTTP_USER_AGENT'])
        handset.xhtml_support_level = '4'
        handset.supports_ajax = 'standard'
        handset
      end
      
      def check_override
        if session[:ajaxified]
          @handset.xhtml_support_level = '4'
          @handset.supports_ajax = 'standard'
        end
      end
        # This no longer sets the request format but instead just give the opportunity to override
        # layouts, templates or partials for specific device capabilities
      def set_mobile_format
        check_override
        Rails.logger.info "[HTTP_USER_AGENT : #{request.headers['HTTP_USER_AGENT']}]"
        Rails.logger.info "[RAILS_CACHE_WURFL-XHTML_SUPPORT_LEVEL] : #{@handset.xhtml_support_level}"
        if @handset.user_agent =~ /(iPhone|Android)/ || ($force == :html5)
          format, @xhtml_support_level = :html5, @handset.xhtml_support_level
          prepend_mobile_format_view_path(@xhtml_support_level)
          prepend_custom_format_view_path(:html5) 
        elsif @handset && @handset.is_wireless_device?
          format, @xhtml_support_level = :mobile,  @handset.xhtml_support_level 
          format = :js if request.format == :js
          prepend_mobile_format_view_path(@xhtml_support_level)
        # else # Just defaulting to mid and assume a mobile site for now
        #   format, @xhtml_support_level = :mobile, @handset.xhtml_support_level
        #   prepend_mobile_format_view_path(@xhtml_support_level)
        end
        Rails.logger.info("[IS_WIRELESS_DEVICE?] : #{@handset.is_wireless_device?}")
        
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
      
      def set_content_type
       if request.accepts.include?(Mime::Type.new('application/vnd.wap.xhtml+xml'))
         type = 'application/vnd.wap.xhtml+xml'
       elsif request.accepts.include?(Mime::Type.new('application/xhtml+xml'))
         type = 'application/xhtml+xml'
       else
         type = 'text/html'
       end
       response.content_type = type + "; charset=utf-8;"
     end
    end
  end
end