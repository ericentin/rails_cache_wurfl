module MobileActive
  module MobileStyleHandler
  
    def stylesheet_link_tag_with_mobilization(*sources)
      opts = sources.extract_options!
      if (@wurfl_device && @wurfl_device.is_wireless_device?)
        new_sources = []
        sources.each do |source|
          source = source.to_s.gsub('.css', '')
          level = @device.xhtml_support_level.to_s rescue nil
          level ||= 'low'
          level = "mid" if level == "high" # force to one stylesheet for now
          new_source = "#{source}_#{level}"
          path = File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,"#{new_source}.css")
          sass_path = File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,"sass","#{new_source}.sass")
          new_sources << new_source if File.exist?(path) || File.exist?(sass_path)
        end
        debugger
        new_sources << opts
        stylesheet_link_tag_without_mobilization(*new_sources)
      else
        stylesheet_link_tag_without_mobilization(*sources)
      end
    end
    
    def stylesheet_cache_key(source)
      if (@wurfl_device && @wurfl_device.is_wireless_device?)
        source = source.to_s.gsub('.css', '')
        level = @device.xhtml_support_level.to_s rescue nil
        level ||= 'low'
        level = "mid" if level == "high" # force to one stylesheet for now
        source = "#{source}_#{level}"
      end
      source
    end
    
  end
end