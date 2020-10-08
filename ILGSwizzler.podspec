Pod::Spec.new do |s|
  s.name         = "ILGSwizzler"
  s.version      = "2.0.0"
  s.summary      = "Class to facilitate method swizzling, particularly for testing."
  s.homepage     = "https://github.com/ilg/ILGSwizzler"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Isaac Greenspan" => "ilg@2718.us" }
  s.source       = { :git => "https://github.com/ilg/ILGSwizzler.git", :tag => "2.0.0" }
  s.source_files = "ILGSwizzler.swift"
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "11.0"
end
