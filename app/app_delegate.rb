class AppDelegate < ProMotion::Delegate

  def on_load(app, options)
    main_screen = MainScreen.new(nav_bar: true)

    if App::Persistence['font_size'].nil?
      App::Persistence['font_size'] = 100
    end

    if Device.ipad?
      open_split_screen main_screen, DetailScreen.new(nav_bar: true), title: "Split Screen Title"
    else
      open main_screen
    end
  end
end
