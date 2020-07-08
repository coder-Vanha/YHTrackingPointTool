
Pod::Spec.new do |s|

  s.name         = "YHTrackingPointTool"
  s.version      = "0.0.2"
  s.summary      = "UITableView & UICollection reload的时候 cellWillDisply 会走多次，不便于埋点，该工具是让cell只曝光一次，停留也只曝光一次"

  s.homepage     = "https://github.com/wanwandiligent/YHTrackingPointTool"
  s.license      = "MIT"

  s.author       = { "wanyehua" => "137177787@qq.com" }
 
  s.platform     = :ios, "9.0"

  s.ios.deployment_target = "9.0"
 
  s.source       = { :git => "https://github.com/wanwandiligent/YHTrackingPointTool.git", :tag => "#{s.version}" }

  s.source_files  = "YHTrackingPointTool", "YHTrackingPointTool/**/*.{h,m}"
  s.exclude_files = "YHTrackingPointTool/Exclude"

  s.requires_arc = true

end
