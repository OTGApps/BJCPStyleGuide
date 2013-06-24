class AboutScreen < PM::WebScreen

  attr_accessor :content, :made_in

  title "About BJCP Styles"

  def content
    self.content || "AboutScreen.html"
  end

  def will_appear
    @view_loaded ||= begin
      set_nav_bar_right_button "Done", action: :close_modal, type: UIBarButtonItemStyleDone

      if self.made_in == true
        self.navigationController.setToolbarHidden(false)
        self.toolbarItems = [flexible_space, made_in_label, flexible_space]
      end

    end
  end

  def made_in_label
    label = set_attributes UILabel.alloc.initWithFrame(CGRectZero), {
      frame: CGRectMake(0.0 , 11.0, view.frame.size.width, 21.0),
      font: UIFont.fontWithName("Helvetica", size:16),
      background_color: UIColor.clearColor,
      text: "Made in Beautiful Charlotte, NC",
      text_alignment: UITextAlignmentCenter
    }
    UIBarButtonItem.alloc.initWithCustomView(label)
  end

  def flexible_space
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
  end

  def close_modal
    self.navigationController.dismissModalViewControllerAnimated(true)
  end

end
