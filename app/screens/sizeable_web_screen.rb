class SizeableWebScreen < PM::WebScreen

  def on_appear
    self.toolbarItems = create_buttons

    @check_timer = 1.second.every do
      check_and_show_toolbar
    end
  end

  def will_disappear
    @check_timer.invalidate if @check_timer
  end

  def check_and_show_toolbar
    if self.navigationController.isToolbarHidden
      self.navigationController.setToolbarHidden(false, animated:toolbar_animated)
    end
  end

  def toolbar_animated
    @_toolbar_animated ||= device.ipad? ? false : true
  end

  def create_buttons
    @_toolbar_buttons ||= begin
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
