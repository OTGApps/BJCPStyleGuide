# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.setup
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'BJCPStyles'
  app.deployment_target = "6.0"
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]
  app.identifier = 'com.yourcompany.BJCPStyles' # I don't like it, but I inherited this app identifier.
  app.version = "16"
  app.short_version = "2.2.1"
  app.frameworks += ["QuartzCore"]
  app.libs << "/usr/lib/libsqlite3.dylib"
  app.prerendered_icon = true
  app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}
  app.info_plist['APP_STORE_ID'] = 293788663
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'com.yourcompany.BJCPStyles',
      'CFBundleURLSchemes' => ['bjcpstyle', 'bjcp'] }
  ]

  app.files_dependencies 'app/Screens/DetailScreen.rb' => 'app/Screens/SizeableWebScreen.rb'
  app.files_dependencies 'app/Screens/IntroScreen.rb'  => 'app/Screens/SizeableWebScreen.rb'

  app.pods do
    pod 'FlurrySDK'
    pod 'Appirater'
    pod 'Harpy'
    pod 'SwipeView'
    pod 'OpenInChrome'
    pod 'SVProgressHUD'
  end

  app.vendor_project('vendor/ContainerSubscriptAccess', :static, :cflags => '-fobjc-arc')

  app.development do
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "/Users/mrickert/.provisioning/WildcardDevelopment.mobileprovision"
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/release.mobileprovision"
  end

end
