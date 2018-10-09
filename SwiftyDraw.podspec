
Pod::Spec.new do |s|
  s.name             = 'SwiftyDraw'
  s.version          = '2.0'
  s.summary          = 'A simple, core graphics drawing framework written in Swift'

  s.description      = <<-DESC
  SwiftyDraw is a simple drawing framework written in Swift. SwiftyDraw is built using Core Gaphics and is very easy to implement
                       DESC

  s.homepage         = 'https://github.com/Awalz/SwiftyDraw'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Linus Geffarth' => 'linus@geffarth.com' }
  s.source           = { :git => 'https://github.com/Awalz/SwiftyDraw.git', :tag => '2.0' }
  s.social_media_url = 'https://twitter.com/linusgeffarth'

  s.ios.deployment_target = '9.1'
  s.swift_version = '4.0'

  s.source_files = 'Source/**/*'

  s.frameworks = 'UIKit'

end
