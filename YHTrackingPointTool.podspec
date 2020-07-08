
Pod::Spec.new do |s|
  s.name         = "YHTrackingPointTool"
  s.version      = "0.0.1"
  s.summary      = "A short description of YHTrackingPointTool."

 
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/wanwandiligent/YHTrackingPointTool"
 
  s.license      = "MIT (example)"
 
  s.author             = { "vanha" => "137177787@qq.com" }

  s.source       = { :git => "https://github.com/wanwandiligent/YHTrackingPointTool.git", :tag => "#{s.version}" }
  s.source_files  = "YHTrackingPointTool", "YHTrackingPointTool/**/*.{h,m}"
  s.exclude_files = "YHTrackingPointTool/Exclude"



end
