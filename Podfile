platform :ios, '11.0'
inhibit_all_warnings!

workspace 'Music.xcworkspace'


def pod_common
  # Rx
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxOptional', '~> 4.0'
  pod 'RxFeedback', '~> 3.0'
  pod 'RxDataSources', '~> 4.0'
  
  pod 'Moya/RxSwift', :git => 'https://github.com/Moya/Moya.git', :tag => '14.0.0-beta.2'

  pod 'Reusable', '~> 4.1.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'Layout', :git => 'https://github.com/librecht-official/Layout.git', :tag => '0.0.4'
end


target 'MusicApp-iOS' do
  project 'MusicApp-iOS/MusicApp-iOS.xcodeproj'
  use_frameworks!

  pod_common
  pod 'SwiftGen', '~> 6.0'

  # target 'Music2Tests' do
  #   inherit! :search_paths
  # end
end

target 'MainKit' do
  project 'MainKit/MainKit.xcodeproj'
  use_frameworks!

  pod_common
end

target 'Core' do
  project 'Core/Core.xcodeproj'
  use_frameworks!

  pod_common
end