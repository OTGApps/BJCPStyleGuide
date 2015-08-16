class IntroScreen < SizeableWebScreen
  attr_accessor :file
  nav_bar true
  
  def on_load
  end

  def content
    self.file
  end

  def load_finished
    super
    css = "#srmtable {float:right;width:50%;}#srmimage{width:50%;float:left;}.clear {clear:both;}"
    evaluate "document.body.innerHTML += '<style>#{css}</style>'" if device.ipad? || device.five_point_five_inch?
  end
end
