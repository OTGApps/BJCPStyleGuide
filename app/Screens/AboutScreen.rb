class AboutScreen < PM::WebScreen
  title I18n.t(:about)

  def content
    Internationalization.resources_path "AboutScreen.html"
  end

  def on_load
    set_nav_bar_button :right, {
      title: I18n.t(:done),
      action: :close
    }
  end

  def will_appear
    Flurry.logEvent "AboutViewed" unless Device.simulator?
  end

end
