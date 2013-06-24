class AppDelegate < ProMotion::Delegate

  def on_load(app, options)

    if defined? TestFlight
      TestFlight.setDeviceIdentifier UIDevice.currentDevice.uniqueIdentifier
      TestFlight.takeOff "e9a2e874-1b13-426c-ad0f-6958e7b2889c"
    end

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
