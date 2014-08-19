Pod::Spec.new do |s|
  s.name         = "ILGSwizzler"
  s.version      = "1.0.0"
  s.summary      = "Class to facilitate method swizzling, particularly for testing."
  s.homepage     = "https://github.com/ilg/ILGSwizzler"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Isaac Greenspan" => "ilg@2718.us" }
  s.source       = { :git => "https://github.com/ilg/ILGSwizzler.git", :tag => "1.0.0" }
  s.source_files = "ILGSwizzler.{h,m}"
  s.requires_arc = false
end
