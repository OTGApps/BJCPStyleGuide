class AboutScreen < PM::WebScreen

  title "About BJCP Styles".__

  def content
    Internationalization.resources_path "AboutScreen.html"
  end

  def will_appear
    @view_loaded ||= begin
      set_nav_bar_right_button "Done".__, action: :close, type: UIBarButtonItemStyleDone

      self.navigationController.setToolbarHidden(false)
      self.toolbarItems = [flexible_space, made_in_label, made_in_image, flexible_space]
    end

    Flurry.logEvent "AboutViewed" unless Device.simulator?
  end

  def made_in_label
    label = set_attributes UILabel.alloc.initWithFrame(CGRectZero), {
      frame: CGRectMake(0.0 , 11.0, view.frame.size.width, 21.0),
      font: UIFont.fontWithName("Helvetica-Bold", size:16),
      background_color: UIColor.clearColor,
      text: "Made in North Carolina".__,
      text_alignment: UITextAlignmentCenter,
      text_color: (Device.ipad? ? UIColor.darkTextColor : UIColor.whiteColor )
    }
    label.sizeToFit
    UIBarButtonItem.alloc.initWithCustomView(label)
  end

  def made_in_image
    image = UIImage.imageNamed("nc.png")
    image_view = set_attributes UIView.new, {
      frame: CGRectMake(0, 0, image.size.width, image.size.height),
    }
    image_view.setBackgroundColor( UIColor.colorWithPatternImage(image) )
    UIBarButtonItem.alloc.initWithCustomView(image_view)
  end

  def flexible_space
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
  end

end
