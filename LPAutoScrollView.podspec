Pod::Spec.new do |s|

s.name                 = "LPAutoScrollView"
s.version              = "1.0.1"
s.summary              = "An easy way to use auto scroll views"
s.homepage             = "https://github.com/watermelon520/LPAutoScrollView"
s.license              = { :type => "MIT", :file => "LICENSE" }
s.author               = { "Loren" => "watermelon_lp@163.com" }
s.platform             = :ios, "7.0"
s.source               = { :git => "https://github.com/watermelon520/LPAutoScrollView", :tag => s.version }
s.source_files         = "LPAutoScrollView/**/*.{h,m}"
s.requires_arc         = true

end