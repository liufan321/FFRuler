Pod::Spec.new do |s|
  s.name         = "FFRuler"
  s.version      = "0.0.1"
  s.summary      = "轻量级标尺控件"
  s.homepage     = "https://github.com/liufan321/FFRuler"
  s.license      = "MIT"
  s.author       = { "刘凡" => "liufan321@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/liufan321/FFRuler.git", :tag => "#{s.version}" }
  s.source_files  = "FFRuler", "FFRuler/FFRuler/FFRulerControl/*.{h,m}"
  s.requires_arc = true
end
