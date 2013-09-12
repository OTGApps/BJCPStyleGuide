class SizeableWebScreen < PM::WebScreen

  def on_appear
    toolbar_animated = Device.ipad? ? false : true
    self.navigationController.setToolbarHidden(false, animated:toolbar_animated)
    self.toolbarItems = Device.ios_version.to_f >= 7.0 ? buttons_ios7 : buttons_ios6
  end

  def buttons_ios6
    increase_size = UIBarButtonItem.alloc.initWithImage(
      "A",
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :increase_size)

    decrease_size = UIBarButtonItem.alloc.initWithImage(
      "a",
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :decrease_size)

    [flexible_space, decrease_size, increase_size]
  end

  def buttons_ios7
    size_label = UIBarButtonItem.alloc.initWithTitle(
      "Text Size:",
      style: UIBarButtonItemStylePlain,
      target: self,
      action: :increase_size)

    increase_size = UIBarButtonItem.alloc.initWithImage(
      "SizeUp".image,
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :increase_size)

    decrease_size = UIBarButtonItem.alloc.initWithImage(
      "SizeDown".image,
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :decrease_size)

    [flexible_space, size_label, decrease_size, increase_size]
  end

  def load_finished
    change_size
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

  def open_about_screen(args={})
    open_modal AboutScreen.new(external_links: true),
      nav_bar: true,
      presentation_style: UIModalPresentationFormSheet,
  end

  def flexible_space
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace,
      target:nil,
      action:nil)
  end

end
