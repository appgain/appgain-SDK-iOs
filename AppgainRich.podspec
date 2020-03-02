Pod::Spec.new do |s|
  s.platform = :ios
  s.name             = 'AppgainRich'
  s.version          = '1.3.6'
  s.summary          = 'Extension for Appgain sdk for rich notification '
 
  s.description      = <<-DESC 
Extension for Appgain sdk for rich notification.
                       DESC
 


  s.homepage         = 'https://github.com/appgain/appgain-SDK-iOs.'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Appgain.io' => 'apps@appgain.io' }
  s.source           = { :git => 'https://github.com/appgain/appgain-SDK-iOs.git', :tag => s.version.to_s }

  s.framework = "UIKit","Foundation","UserNotifications","UserNotificationsUI","AVKit","WebKit"
  s.ios.deployment_target = '11.0'
	s.vendored_frameworks = 'AppgainSDK/Appgain-rich/AppgainRich.framework'


 s.source_files = 'AppgainSDK/Appgain-rich/AppgainRich.h'
end
