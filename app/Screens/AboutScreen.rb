class AboutScreen < PM::WebScreen

  title "About BJCP Styles".__

  def content
    Internationalization.resources_path "AboutScreen.html"
  end

  def on_load
    set_nav_bar_button :right, {
      title: "Done".__,
      action: :close
    }
  end

  def will_appear
    Flurry.logEvent "AboutViewed" unless Device.simulator?
  end

end
