#
#  Be sure to run `pod spec lint HZFNoDataKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HZFNoDataKit"
  s.version      = "0.0.1"
  s.summary      = "零代码控制UITableView、UICollectionView空视图"

  s.description  = <<-DESC 
  零代码控制UITableView、UICollectionView空视图
                   DESC

  s.homepage     = "https://github.com/huangzhifei/HZFNoDataKit"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "eric" => "huangzhifei2009@126.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/huangzhifei/HZFNoDataKit", :tag => s.version }

  s.source_files  = "Pod/Classes/HZFNoDataKit/*.{h,m}"

  s.frameworks = 'UIKit', 'Foundation'

  s.requires_arc = true
  
end