
Pod::Spec.new do |spec|

  spec.name         = "LJXCustomAlert"
  spec.version      = "0.0.3"
  spec.summary      = "A short description of LJXCustomAlert."

  spec.description  = <<-DESC
		A short description of CustomAlertView and CustomActionSheetView .
                   DESC

  spec.homepage     = "https://github.com/MrLuanJX/CustomAlert.git"

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author             = { "MrLuanJX" => "22392372@qq.com" }

 spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/MrLuanJX/CustomAlert.git", :tag => "#{spec.version}" }


  spec.source_files  = "CustomAlert/LJXCustomAlert/**/*.{h,m}"
  spec.exclude_files = "CustomAlert/Exclude"

  # spec.public_header_files = "Classes/**/*.h"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # spec.requires_arc = true

  spec.dependency "Masonry", "~> 1.1.0"

end
