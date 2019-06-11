Pod::Spec.new do |s|
  s.platform = :ios
  s.name             = 'Appgain-Rich'
  s.version          = '1.1.3'
  s.summary          = 'Extension for Appgain sdk for rich notification '
 
  s.description      = <<-DESC 
Extension for Appgain sdk for rich notification.
                       DESC
 


  s.homepage         = 'https://github.com/appgain/appgain-SDK-iOs.'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Appgain.io' => 'apps@appgain.io' }
  s.source           = { :git => 'https://github.com/appgain/appgain-SDK-iOs.git', :tag => s.version.to_s }

  s.framework = "UIKit","Foundation","UserNotifications","UserNotificationsUI","AVKit","WebKit"
  s.ios.deployment_target = '10.0'

  s.source_files = 'AppgainSDK/Appgain-rich/AppgainRich.m','AppgainSDK/Appgain-rich/AppgainRich.h'

end
