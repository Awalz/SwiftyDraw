#
# Be sure to run `pod lib lint SwiftyDraw.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyDraw'
  s.version          = '2.0'
  s.summary          = 'A simple, core graphics drawing framework written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SwiftyDraw is a simple drawing framework written in Swift. SwiftyDraw is built using Core Gaphics and is very easy to implement
                       DESC

  s.homepage         = 'https://github.com/Awalz/SwiftyDraw'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Andrew Walz' => 'andrewjwalz@gmail.com' }
  s.source           = { :git => 'https://github.com/Awalz/SwiftyDraw.git', :tag => '2.0' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.1'

  s.source_files = 'Source/**/*'

  # s.resource_bundles = {
  #   'SwiftyDraw' => ['SwiftyDraw/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
