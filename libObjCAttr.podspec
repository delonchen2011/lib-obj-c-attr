Pod::Spec.new do |s|
  s.name             = "libObjCAttr"
  s.version          = "1.3.6"
  s.summary          = "Attribute-oriented programming library & tooling for iOS and OSX."
  s.description      = <<-DESC
                       Library implements [Attribute-Oriented Programming](https://en.wikipedia.org/wiki/Attribute-oriented_programming) paradigm in Objective-C. It allows to add various metadata to the class, each method, property or ivar of the class.
                       DESC
  s.homepage         = "https://github.com/epam/lib-obj-c-attr"
  s.license          = 'BSD-3'
  s.author           = { 'EPAM Systems, Inc' => 'SupportROAD@epam.com' }
  s.source           = { :git => "https://github.com/delonchen2011/lib-obj-c-attr.git", :tag => '1.3.6' }

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
  
  s.requires_arc = true

  s.source_files = 'libObjCAttr/**/*.{h,m}', 'libObjCAttr/Resources/*', 'tools/binaries/*'
  s.public_header_files = 'libObjCAttr/**/*.h'
  s.header_dir = 'ROAD'
  s.preserve_paths = 'libObjCAttr/Resources/*', 'tools/binaries/ROADAttributesCodeGenerator'
  
  s.social_media_url = 'https://twitter.com/libobjcattr'

end
