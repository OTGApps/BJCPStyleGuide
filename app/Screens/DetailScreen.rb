class DetailScreen < PM::WebScreen
  attr_accessor :style, :cell

  def will_appear
    @view_loaded ||= begin

      if Device.ipad?
        set_nav_bar_right_button UIImage.imageNamed("info.png"), action: :open_info_screen
      end

      unless self.cell.nil?
        self.setTitle self.cell[:title]
        set_attributes view, {background_color:UIColor.whiteColor}
      else
        self.setTitle "Welcome"
        set_attributes view, {background_color:"#CCCC99".to_color}
      end
    end
  end

  def on_appear
    return if self.cell.nil?

    flexible_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace,
      target:nil,
      action:nil)

    increase_size = UIBarButtonItem.alloc.initWithTitle(
      "A",
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :increase_size)

    decrease_size = UIBarButtonItem.alloc.initWithTitle(
      "a",
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :decrease_size)


    toolbar_animated = Device.ipad? ? false : true
    self.navigationController.setToolbarHidden(false, animated:toolbar_animated)
    self.toolbarItems = [flexible_space, decrease_size, increase_size]

    unless self.cell.nil?
      flurry_params = {style: self.cell[:title]}
      Flurry.logEvent("ViewedStyle", withParameters:flurry_params) unless Device.simulator?
    end
  end

  def load_finished
    change_size
    set_srm_range
  end

  def content
    return "DefaultScreen.html" if self.style.nil?

    <<-CONTENT

#{css}

<div class="srmrange">&nbsp;</div>
<h1>#{self.cell[:title]}</h1>
<div class="srmrange">&nbsp;</div>

#{style.html(:aroma)}
#{style.html(:appearance)}
#{style.html(:flavor)}
#{style.html(:mouthfeel)}
#{style.html(:impression)}
#{style.html(:comments)}
#{style.html(:history)}
#{style.html(:ingredients)}
#{style.html(:specs)}
#{style.html(:examples)}

    CONTENT
  end

  def css
    "<style>" << File.read(File.join(App.resources_path, "style.css")) << "</style>"
  end

  def set_srm_range
    if style.nil? || style.srm_range.nil?
      gradient = "display:none;"
    else
      gradient = SRM.css_gradient(style.srm_range) unless style.nil?
    end
    evaluate "document.body.innerHTML += '<style>.srmrange{#{gradient}}</style>'"
  end

  def increase_size(args={})
    size_mover(10)
  end

  def decrease_size(args={})
    size_mover(-10)
  end

  def size_mover(which_way)
    App::Persistence['font_size'] = App::Persistence['font_size'] + which_way
    change_size
  end

  def change_size
    evaluate "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '#{App::Persistence['font_size']}%'",
  end

  def open_info_screen(args={})
    open_modal AboutScreen.new(external_links: true),
      nav_bar: true,
      presentation_style: UIModalPresentationFormSheet,
  end

end
