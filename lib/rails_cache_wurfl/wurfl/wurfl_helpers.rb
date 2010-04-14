module WurflHelpers
  def supports_css?
    [:low, :mid, :high].include?(xhtml_support_level)
  end
  
  def supported_device?
    xhtml_support_level != :none
  end
  
  def xhtml_support_level
    @xhtml_support_level ||= capability(:xhtml_support_level)
    case @xhtml_support_level
    when '-1'
      # no XHTML support at all
      return :none
    when '0'
      # basic XHTML, no CSS support
      return :basic
    when '1'
      # basic XHTML, some CSS support
      return :low
    when '2'
      # much the same as 1, some grey area
      return :low
    when '3'
      # Full XHTML with excellent CSS support
      return :mid
    when '3.5' 
      # Special case
      return :mid_high
    when '4'
      # Awesomeness, iPhone and so on
      return :high
    end
  end
  
  def xhtml_support_level=(value)
    @xhtml_support_level = value
  end
  
  def low?
    [:none, :basic, :low].include?(xhtml_support_level)
  end
  
  def supports_javascript?
    capability(:ajax_support_javascript)
  end
    
  def supports_javascript_css_manipulation?
    capability(:ajax_manipulate_css)
  end
  
  def supports_external_css?
    [:high, :mid].include?(xhtml_support_level)
  end
  
  def supports_css?
    [:low, :mid, :high].include?(xhtml_support_level)
  end
  
  def supports_ajax?
    capability(:ajax_xhr_type) != 'none'
  end
  
  def supports_j2me_midp_1_0?
    capability(:j2me_midp_1_0) != 'none'
  end
  
  def supports_j2me_cldc_1_0?
    capability(:j2me_cldc_1_0) != 'none'
  end
  
  def supports_j2me_midp_2_0?
    capability(:j2me_midp_2_0) != 'none'
  end
  
  def supports_j2me_cldc_1_1?
    capability(:j2me_cldc_1_1) != 'none'
  end
  
  def is_wireless_device?
    capability(:is_wireless_device)
  end
  
  # TODO remove, this is lame
  def browser_is_wap?
    capability(:is_wireless_device)
  end

  def brand
    capability(:brand_name)
  end

  def model
    capability(:model_name)
  end
end