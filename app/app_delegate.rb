class AppDelegate < ProMotion::Delegate

  def on_load(app, options)
    open StylesScreen.new(nav_bar: true)
  end
end
