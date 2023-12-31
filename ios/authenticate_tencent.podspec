#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint authenticate_tencent.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'authenticate_tencent'
  s.version          = '0.0.2'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://www.saywo.cn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'pgrammer.ybj@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  s.frameworks = ["UIKit", "AVFoundation", "CoreVideo", "Security", "SystemConfiguration", "CoreMedia", "VideoToolbox", "CoreTelephony", "ImageIO", "Accelerate", "WebKit", 'MediaPlayer']
  s.libraries = ["c++","z"]

  s.ios.vendored_framework   = 'Libs/*.framework'
  s.ios.resource = 'Resources/*.bundle'
end

