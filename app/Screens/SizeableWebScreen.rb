class SizeableWebScreen < PM::WebScreen

  def on_appear
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

end
