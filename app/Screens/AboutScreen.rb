class AboutScreen < PM::WebScreen

  title "About BJCP Styles"

  def content
    "AboutScreen.html"
  end

  def will_appear
    @view_loaded ||= begin
      set_nav_bar_right_button "Done", action: :close_modal, type: UIBarButtonItemStyleDone
    end
  end

  def close_modal
    self.navigationController.dismissModalViewControllerAnimated(true)
  end

end
