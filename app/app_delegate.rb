class AppDelegate < ProMotion::Delegate

  def on_load(app, options)

    if defined? TestFlight
      TestFlight.setDeviceIdentifier UIDevice.currentDevice.uniqueIdentifier
      TestFlight.takeOff "e9a2e874-1b13-426c-ad0f-6958e7b2889c"
    end

    # 3rd Party integrations
    unless Device.simulator?
      app_id = NSBundle.mainBundle.objectForInfoDictionaryKey('APP_STORE_ID')

      # Flurry
      NSSetUncaughtExceptionHandler("uncaughtExceptionHandler")
      Flurry.startSession("YSNRBSKM9B3ZZXPG7CG7")

      # Appirater
      Appirater.setAppId app_id
      Appirater.setDaysUntilPrompt 5
      Appirater.setUsesUntilPrompt 10
      Appirater.setTimeBeforeReminding 5
      Appirater.appLaunched true

      # Harpy
      Harpy.sharedInstance.setAppID app_id
      Harpy.sharedInstance.checkVersion
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

  #Flurry exception handler
  def uncaughtExceptionHandler(exception)
    Flurry.logError("Uncaught", message:"Crash!", exception:exception)
  end

  def applicationWillEnterForeground(application)
    Appirater.appEnteredForeground true unless Device.simulator?
  end

end
