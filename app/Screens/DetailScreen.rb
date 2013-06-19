class DetailScreen < PM::WebScreen
  attr_accessor :data, :cell

  def will_appear
    @view_loaded ||= begin
      unless self.cell.nil?
        self.setTitle self.cell[:title]
        set_attributes view, {background_color:UIColor.whiteColor}
      else
        self.setTitle "Welcome"
        set_attributes view, {background_color:"#CCCC99".to_color}
      end

      self.navigationController.setToolbarHidden(false)

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

      self.toolbarItems = [flexible_space, decrease_size, increase_size]

      if App::Persistence['font_size'].nil?
        App::Persistence['font_size'] = 100
      end

    end
  end

  def load_finished
    change_size
    set_srm_range
  end

  def content
    return "DefaultScreen.html" if self.data.nil?

    <<-CONTENT

#{css}

<div class="srmrange">&nbsp;</div>
<h1>#{self.cell[:title]}</h1>
<div class="srmrange">&nbsp;</div>

<h2>Aroma</h2>
<p>#{aroma}</p>

<h2>Appearance</h2>
<p>#{appearance}</p>

<h2>Flavor</h2>
<p>#{flavor}</p>

<h2>Mouthfeel</h2>
<p>#{mouthfeel}</p>

<h2>Overall Impression</h2>
<p>#{impression}</p>

<h2>Comments</h2>
<p>#{comments}</p>

<h2>History</h2>
<p>#{history}</p>

<h2>Ingredients</h2>
<p>#{ingredients}</p>

<h2>Vital Statistics</h2>
<ul>#{vital_stats}</ul>

<h2>Commercial Examples</h2>
<p>#{examples}</p>

    CONTENT
  end

  def css
    "<style>" << File.read(File.join(App.resources_path, "style.css")) << "</style>"
  end

  def vital_stats
    table = ""

    %w(og fg ibu srm abv).each do |stat|
      unless stats[stat].nil?
        table << "<li>" + stat.upcase + ": " + vital_stats_low_high(stats[stat]) + "</li>"
      end
    end
    table
  end

  def vital_stats_low_high(stat)
    if stat["flexible"] == "false"
      stat["low"] + "-" + stat["high"]
    else
      "N/A"
    end
  end

  def set_srm_range
    if defined? stats["srm"]["low"]
      gradient = SRM.css_gradient(stats["srm"]["low"], stats["srm"]["high"])
    else
      gradient = "display:none;"
    end
    evaluate "document.body.innerHTML += '<style>.srmrange{#{gradient}}</style>'"
  end

  def increase_size(args={})
    App::Persistence['font_size'] = App::Persistence['font_size'] + 10
    change_size
  end

  def decrease_size(args={})
    App::Persistence['font_size'] = App::Persistence['font_size'] - 10
    change_size
  end

  def change_size
    evaluate "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '#{App::Persistence['font_size']}%'",
  end

  def method_missing(meth, *args, &block)
    unless self.data[meth.to_s].nil?
      if self.data[meth.to_s].is_a? String
        self.data[meth.to_s].gsub("[em]", "<em>").gsub("[/em]", "</em>")
      else
        self.data[meth.to_s]
      end
    else
      "N/A"
    end
  end

end
