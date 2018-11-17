Pod::Spec.new do |s|
  s.platform = :ios
  s.name             = 'Appgain'
  s.version          = '1.0.9'
  s.summary          = 'Appgain   component for iOS '
 
  s.description      = <<-DESC
Appgain component for using in iOS!, that support many thing like push notification and seat links and notification tracking and create smartLink create landingPage  .
                       DESC
 
  s.homepage         = 'https://github.com/appgain/appgain-SDK-iOs.'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Appgain.io' => 'apps@appgain.io' }
  s.source           = { :git => 'https://github.com/appgain/appgain-SDK-iOs.git', :tag => s.version.to_s }
 
  s.framework = "UIKit"
  s.ios.deployment_target = '8.0'

  s.dependency 'Parse', '~> 1.14.4'
  s.source_files = 'AppgainSDK/*.m','AppgainSDK/*.h'

end