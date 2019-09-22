platform :ios, '11.0'
inhibit_all_warnings!

def pods
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
    
  pod 'SwiftGen', '~> 6.0'
end

target 'Music2' do
  use_frameworks!
  pods
end

target 'Music2Tests' do
  use_frameworks!
end
