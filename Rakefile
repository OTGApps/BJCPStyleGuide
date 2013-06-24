# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'BJCPStyles'
  app.deployment_target = "5.0"
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]
  app.identifier = 'com.yourcompany.BJCPStyles' # I don't like it, but I inherited this app identifier.
  app.version = "3"
  app.short_version = "2.0.0"
  app.frameworks << "/usr/lib/libsqlite3.dylib"
  app.prerendered_icon = true

  app.pods do
    pod 'FlurrySDK'
    pod 'TestFlightSDK'
  end

  app.development do
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "./provisioning/development.mobileprovision"
  end

  app.testflight do
    app.testflight.api_token = ENV['testflight_api_token'] || abort("You need to set your Testflight API Token environment variable.")
    app.testflight.team_token = '5f6f10ca05bf5be29ba522bc4e9c504f_MjM4MDE0MjAxMy0wNi0xOCAxMDoxNTo0Mi44MzEyODE'

    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/adhoc.mobileprovision"
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/release.mobileprovision"
  end

end
