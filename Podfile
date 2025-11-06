# Uncomment the next line to define a global platform for your project
# platform :ios, '14.2'
 use_frameworks!

target 'FarmerConnect' do

pod 'Alamofire','~> 4.9.1'
pod 'GoogleMaps',  '~> 4.0.0'
pod 'GooglePlaces' , '~> 4.0.0'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'SDWebImage', '~> 4.0'
#pod 'AWSS3'
#pod 'UQScanner', :git => 'https://gitlab.com/uniqolabel/iOS/pod-uqscanner.git', :tag => '3.0.7'
pod "JWT"
pod 'JWTDecode', '~> 2.4'
pod 'Kingfisher', '~> 5.0'
pod 'Toast-Swift', '~> 5.0.0'
pod 'SwiftyGif'
pod 'FBSDKShareKit'
pod 'AWSS3', '~> 2.19.1'
pod 'FBSDKLoginKit'
pod 'FBSDKCoreKit'
#pod 'AcvissCore', :git => 'https://gitlab.com/acviss-ios/private-pods/acviss-core.git'
#pod 'Acvission', :git => 'https://gitlab.com/acviss-ios/private-pods/acvission.git'
#pod 'ZXingObjC'

#pod 'AcvissCore', :git =>   'https://gitlab.com/acviss-ios/private-pods/acviss-core.git', :branch => 'react'
#pod 'Acvission', :git => 'https://gitlab.com/acviss-ios/private-pods/acvission.git', :branch => 'react'

#pod 'AcvissCore', :git =>   'https://gitlab.com/acviss-ios/private-pods/acviss-core.git', :branch => 'react-14.2xcode'
#pod 'Acvission', :git => 'https://gitlab.com/acviss-ios/private-pods/acvission.git', :branch => 'react-14.2xcode'

#pod 'AcvissCore', :git =>   'https://gitlab.com/acviss-ios/private-pods/acviss-core.git', :branch => 'react-15.3xcode'
#pod 'Acvission', :git => 'https://gitlab.com/acviss-ios/private-pods/acvission.git', :branch => 'react-15.3xcode'
#pod 'ZXingObjC'

pod 'AcvissCore', :git =>   'https://gitlab.com/acviss-ios/private-pods/acviss-core.git', :branch => 'appstore-xc15'
pod 'Acvission', :git => 'https://gitlab.com/acviss-ios/private-pods/acvission.git', :branch => 'appstore-xc15'
pod 'ZXingObjC'


  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FarmerConnect

  target 'FarmerConnectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FarmerConnectUITests' do
    # Pods for testing
  end

#post_install do |installer|
#  installer.pods_project.build_configurations.each do |config|
#    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#  end
#end

end

target 'NotificationMediaExtention' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NotificationMediaExtention

end

target 'RichNotificationContent' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RichNotificationContent

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end

