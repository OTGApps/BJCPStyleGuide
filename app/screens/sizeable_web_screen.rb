class SizeableWebScreen < PM::WebScreen

  def on_appear
    toolbar_animated = (device.ipad? || device.five_point_five_inch?) ? false : true
    self.navigationController.setToolbarHidden(false, animated:toolbar_animated)
    self.toolbarItems = create_buttons
  end

  def create_buttons
    size_label = UIBarButtonItem.alloc.initWithTitle(
      "Text Size:",
      style: UIBarButtonItemStylePlain,
      target: self,
      action: :increase_size)

    increase_size_button = UIBarButtonItem.alloc.initWithImage(
      "SizeUp".image,
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :increase_size)

    decrease_size_button = UIBarButtonItem.alloc.initWithImage(
      "SizeDown".image,
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: :decrease_size)

    [flexible_space, size_label, decrease_size_button, increase_size_button]
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

  def flexible_space
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace,
      target:nil,
      action:nil)
  end

end
