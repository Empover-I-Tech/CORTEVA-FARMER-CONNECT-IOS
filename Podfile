
platform :ios, '13.0'

target 'Pioneer FarmFirst' do

  pod 'Alamofire','~> 4.9.1'
  pod 'GoogleMaps',  '4.0.0'
  pod 'GooglePlaces' , '4.0.0'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'SDWebImage', '~> 4.0'
  pod "JWT"
  pod 'JWTDecode', '~> 2.4'
  pod 'Kingfisher', '~> 5.0'
  pod 'Toast-Swift', '~> 5.0.0'
  pod 'SwiftyGif'
  pod 'FBSDKShareKit'
  pod 'AWSS3', '~> 2.19.1'
  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'

  target 'Pioneer FarmFirstTests' do
    inherit! :search_paths
  end

end

# ✅ EXTENSIONS (OUTSIDE MAIN TARGET)

target 'RichNotificationContent' do
  inherit! :search_paths
end

target 'NotificationMediaExtention' do
  inherit! :search_paths
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
