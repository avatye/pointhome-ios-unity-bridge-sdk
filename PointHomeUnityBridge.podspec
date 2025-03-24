Pod::Spec.new do |spec|

  sdk_version = "1.8.4.1"

  avatye_point_home_version = "1.8.4"
  app_lovin_version = "13.0.1"
  ads_pangle_version = "6.2.0.5"
  unity_ads_version = "4.12.5"
  vungle_ads_version = "7.4.1"
  fb_audience_network_version = "6.14.0"

  spec.name = "PointHomeUnityBridge"
  spec.version = sdk_version
  spec.summary = "Avatye pointhome IOS-Unity bridge"

  spec.description = <<-DESC
  Avatye pointhome IOS-Unity bridge.(SDK)
  DESC

  spec.homepage = "https://github.com/avatye/pointhome-ios-unity-bridge-sdk"
  spec.license = {:type => "MIT", :text => "Copyright (c) 2024 Avatye Corp."}
  spec.author = {"YoungSue" => "yspark@avatye.com"}

  spec.source = {:git => "https://github.com/avatye/pointhome-ios-unity-bridge-sdk.git", :tag => spec.version.to_s}

  spec.ios.deployment_target = "13.0"

  spec.swift_versions = ["5.0"]

  spec.static_framework = true


  # spec.public_header_files = "PointHomeUnityBridge//**/*.h"

    spec.dependency("AvatyePointHome", avatye_point_home_version)
    spec.dependency("AppLovinSDK", app_lovin_version)
    spec.dependency("Ads-Global", ads_pangle_version)
    spec.dependency("UnityAds", unity_ads_version)
    spec.dependency("VungleAds", vungle_ads_version)
    spec.dependency("FBAudienceNetwork", fb_audience_network_version)

    spec.source_files = "PointHomeUnityBridge/*.{h,m,mm,swift}",
"PointHomeUnityBridge/AppLovin/*.{h,m,mm,swift}",
"PointHomeUnityBridge/Pangle/*.{h,m,mm,swift}",
"PointHomeUnityBridge/Unity/*.{h,m,mm,swift}",
"PointHomeUnityBridge/Vungle/*.{h,m,mm,swift}",
"PointHomeUnityBridge/Facebook/*.{h,m,mm,swift}"



end
