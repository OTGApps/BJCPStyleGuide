# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
$:.unshift("~/.rubymotion/rubymotion-templates")

require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  define_icon_defaults!(app)
  app.info_plist['UILaunchStoryboardName'] = 'LaunchScreen'

  app.name = 'BJCPStyles'
  app.identifier = 'com.yourcompany.BJCPStyles' # I don't like it, but I inherited this app identifier.

  app.short_version = "4.0.0"
  app.version = (`git rev-list HEAD --count`.strip.to_i).to_s

  app.deployment_target = "11.2"
  app.info_plist['UIRequiredDeviceCapabilities'] = ['arm64']
  app.archs['iPhoneOS'] = ['arm64']
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]

  app.frameworks += ["QuartzCore"]
  app.libs << "/usr/lib/libsqlite3.dylib"

  app.info_plist['CFBundleIcons'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60']
    }
  }

  app.info_plist['CFBundleIcons~ipad'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60', 'AppIcon76x76']
    }
  }

  app.info_plist['UIRequiresFullScreen'] = true
  app.info_plist['ITSAppUsesNonExemptEncryption'] = false
  app.info_plist['APP_STORE_ID'] = 293788663
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => app.identifier,
      'CFBundleURLSchemes' => ['bjcpstyle', 'bjcp'] }
  ]
  app.info_plist["LSApplicationQueriesSchemes"] = ['beerjudge', 'beerjudge://']

  app.files_dependencies 'app/screens/detail_screen.rb' => 'app/screens/sizeable_web_screen.rb'
  app.files_dependencies 'app/screens/intro_screen.rb'  => 'app/screens/sizeable_web_screen.rb'

  app.pods do
    pod 'Appirater'
    pod 'OpenInChrome'
    pod 'EAIntroView', '~> 2.7.0'
  end

  MotionProvisioning.output_path = '../provisioning'
  app.development do
    app.entitlements['get-task-allow'] = true

    app.codesign_certificate = MotionProvisioning.certificate(
      type: :development,
      platform: :ios)

    app.provisioning_profile = MotionProvisioning.profile(
      bundle_identifier: app.identifier,
      app_name: app.name,
      platform: :ios,
      type: :development)
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.entitlements['beta-reports-active'] = true

    app.codesign_certificate = MotionProvisioning.certificate(
      type: :distribution,
      platform: :ios)

    app.provisioning_profile = MotionProvisioning.profile(
      bundle_identifier: app.identifier,
      app_name: app.name,
      platform: :ios,
      type: :distribution)
  end

end

def define_icon_defaults!(app)
  # This is required as of iOS 11.0 (you must use asset catalogs to
  # define icons or your app will be rejected. More information in
  # located in the readme.

  app.info_plist['CFBundleIcons'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60']
    }
  }

  app.info_plist['CFBundleIcons~ipad'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60', 'AppIcon76x76']
    }
  }
end
