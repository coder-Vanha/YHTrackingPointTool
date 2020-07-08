
Pod::Spec.new do |s|
  s.name         = "YHTrackingPointTool"
  s.version      = "0.0.2"
  s.summary      = "A short description of YHTrackingPointTool."
  s.homepage     = "https://github.com/wanwandiligent/YHTrackingPointTool"
  s.license      = "MIT"
  s.author       = { "vanha" => "137177787@qq.com" }
  s.source       = { :git => "https://github.com/wanwandiligent/YHTrackingPointTool.git", :tag => s.version}
  s.source_files  = "YHTrackingPointTool/**/*.{h,m}"
  s.requires_arc = true

end
