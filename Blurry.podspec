Pod::Spec.new do |s|
  s.name = 'Blurry'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'Image Blurring in Swift'
  s.homepage = 'https://github.com/piemonte/Blurry'
  s.authors = { 'patrick piemonte' => 'patrick.piemonte@gmail.com' }
  s.source = { :git => 'https://github.com/piemonte/Blurry.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
  s.swift_version = '4.2'
  s.screenshot = 'https://raw.githubusercontent.com/piemonte/Blurry/master/Blurry.png'
end
