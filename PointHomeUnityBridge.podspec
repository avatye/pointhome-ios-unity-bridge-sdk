Pod::Spec.new do |spec|

  sdk_version = "1.8.5.3"

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

   spec.dependency 'AvatyePointHome', '1.8.5.0'

   spec.source_files = "PointHomeUnityBridge/*.{h,m,mm,swift}"

  # spec.static_framework = true
  # spec.public_header_files = "PointHomeUnityBridge//**/*.h"



end
