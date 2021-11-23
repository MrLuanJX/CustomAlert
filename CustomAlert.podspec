

Pod::Spec.new do |s|

  s.name         = "CustomAlert"
  s.version      = "0.0.2"
  s.summary      = " CustomAlertView and CustomActionSheetView ."
  s.description  = <<-DESC
                   A short description of CustomAlertView and CustomActionSheetView .
                   DESC
 
  s.homepage     = "https://github.com/MrLuanJX/CustomAlert.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "MrLuanJX" => "22392372@qq.com" }
  s.platform     = :ios, "9.0" 
  s.source       = { :git => "https://github.com/MrLuanJX/CustomAlert.git", :tag => "#{s.version}"}
  s.source_files  = "CustomAlert/LJXCustomAlert/**/*.{h,m}"

  s.dependency "Masonry", "~> 1.1.0"

end
