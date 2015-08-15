class IntroScreen < SizeableWebScreen

  attr_accessor :file

  def on_load
    if Device.ipad?
      set_nav_bar_right_button UIImage.imageNamed("info.png"), action: :open_about_screen
    end
  end

  def content
    self.file
  end

  def will_appear
  end

  def load_finished
    super
    css = "#srmtable {float:right;width:50%;}#srmimage{width:50%;float:left;}.clear {clear:both;}"
    evaluate "document.body.innerHTML += '<style>#{css}</style>'" if Device.ipad?
  end
end
