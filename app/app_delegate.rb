class AppDelegate < ProMotion::Delegate
  tint_color "#D3541F".to_color

  attr_accessor :jump_to_style, :main_screen

  def on_load(app, options)

    # 3rd Party integrations
    unless Device.simulator?
      app_id = App.info_plist['APP_STORE_ID']

      # Appirater
      Appirater.setAppId app_id
      Appirater.setDaysUntilPrompt 5
      Appirater.setUsesUntilPrompt 10
      Appirater.setTimeBeforeReminding 5
      Appirater.appLaunched true

      # Crittercism Debugging on devices
      crittercism_app_id = "55d0cd57985ec40d0002c59b"
      Crittercism.enableWithAppID(crittercism_app_id)
    end

    # Set initial font size (%)
    App::Persistence['font_size'] = 100 if App::Persistence['font_size'].nil?

    @main_screen = MainScreen.new(nav_bar: true)

    # Check to see if the user is calling a style from an external URL when the application isn't in memory yet
    if options.is_a?(Hash) && options[UIApplicationLaunchOptionsURLKey] && options[UIApplicationLaunchOptionsURLKey].is_a?(NSURL)
      suffix = options[UIApplicationLaunchOptionsURLKey].absoluteString.split("//").last
      open_style_when_launched(suffix)
    end

    if device.ipad?
      open_split_screen @main_screen, DetailScreen.new(nav_bar: true)
    else
      open @main_screen
    end
  end

  def will_enter_foreground
    Appirater.appEnteredForeground(true) unless Device.simulator?
  end

  # def application(application, openURL:url, sourceApplication:sourceApplication, annotation:annotation)
  def on_open_url(args={})
    Version.set('2015')

    suffix = args[:url].absoluteString.split("//").last

    if suffix == "reset_tools"
      App::Persistence['hide_judging_tools'] = nil
      App.notification_center.post "ReloadNotification"
    else
      open_style_when_launched(suffix)
    end

    true
  end

  def open_style_when_launched(style)
    self.jump_to_style = style
    App.notification_center.post("GoDirectlyToStyle", object:style)
  end

end
