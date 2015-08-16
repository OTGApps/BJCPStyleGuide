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
  app.identifier = 'com.yourcompany.BJCPStyles' # I don't like it, but I inherited this app identifier.

  app.short_version = "2.2.1"
  app.version = (`git rev-list HEAD --count`.strip.to_i).to_s

  app.deployment_target = "7.0"

  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]

  app.frameworks += ["QuartzCore"]
  app.libs << "/usr/lib/libsqlite3.dylib"

  app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}

  app.info_plist['APP_STORE_ID'] = 293788663
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'com.yourcompany.BJCPStyles',
      'CFBundleURLSchemes' => ['bjcpstyle', 'bjcp'] }
  ]

  app.files_dependencies 'app/screens/detail_screen.rb' => 'app/screens/sizeable_web_screen.rb'
  app.files_dependencies 'app/screens/intro_screen.rb'  => 'app/screens/sizeable_web_screen.rb'

  app.pods do
    pod 'Appirater'
    pod 'OpenInChrome'
    pod 'EAIntroView', '~> 2.7.0'
  end

  app.development do
    # We only want this cocoapod in development mode.
    app.pods do
      # pod "Reveal-iOS-SDK"
    end

    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "./provisioning/development.mobileprovision"
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/release.mobileprovision"
  end

end

desc "Run simulator on iPhone"
task :iphone4 do
    exec 'bundle exec rake device_name="iPhone 4s"'
end

desc "Run simulator on iPhone"
task :iphone5 do
    exec 'bundle exec rake device_name="iPhone 5"'
end

desc "Run simulator on iPhone"
task :iphone6 do
    exec 'bundle exec rake device_name="iPhone 6"'
end

desc "Run simulator on iPhone"
task :iphone6_plus do
    exec 'bundle exec rake device_name="iPhone 6 Plus"'
end

desc "Run simulator in iPad Retina"
task :retina do
    exec 'bundle exec rake device_name="iPad Retina"'
end

desc "Run simulator on iPad Air"
task :ipad do
    exec 'bundle exec rake device_name="iPad Air"'
end
