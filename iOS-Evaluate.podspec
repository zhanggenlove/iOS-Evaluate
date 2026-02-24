Pod::Spec.new do |s|
  s.name             = 'iOS-Evaluate'
  s.version          = '2.0.0'
  s.summary          = 'A modern, beautiful app review prompt library for iOS 26+.'

  s.description      = <<-DESC
    iOS-Evaluate is a modern, beautiful app review prompt library for iOS 26+.
    Built with SwiftUI gradient design, Swift 6 concurrency, and full
    localization support for 30+ languages. Features include gradient buttons,
    animated star icons, haptic feedback, and both SwiftUI and UIKit integration.
  DESC

  s.homepage         = 'https://github.com/zhanggenlove/iOS-Evaluate'
  s.screenshots      = 'https://raw.githubusercontent.com/zhanggenlove/iOS-Evaluate/main/Assets/preview.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhanggen' => 'zhanggenlove@gmail.com' }
  s.source           = { :git => 'https://github.com/zhanggenlove/iOS-Evaluate.git', :tag => s.version.to_s }

  s.ios.deployment_target = '26.0'
  s.swift_versions        = ['6.2']

  s.source_files  = 'Sources/iOS-Evaluate/**/*.swift'
  s.resources     = 'Sources/iOS-Evaluate/Resources/**/*.strings'

  s.frameworks = 'UIKit', 'StoreKit', 'SwiftUI'
end
