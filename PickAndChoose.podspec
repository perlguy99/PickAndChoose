#
#  Be sure to run `pod spec lint PickAndChoose.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

spec.platform              = :ios
spec.ios.deployment_target = '11.0'
spec.name                  = "PickAndChoose"
spec.summary               = "A UILabel integrated with a UIPicker."
spec.requires_arc          = true

spec.version               = "1.0.2"

spec.license               = { :type => "MIT", :file => "LICENSE" }

spec.homepage              = "https://github.com/perlguy99/PickAndChoose"

spec.author                = { "Brent Michalski" => "Brent.Michalski@gmail.com" }
spec.social_media_url      = "https://twitter.com/Perlguy2"

spec.source                = { :git => "https://github.com/perlguy99/PickAndChoose.git", :tag => "#{spec.version}" }

spec.framework             = "UIKit"

spec.source_files          = "PickAndChoose/**/*.{swift}"

# 9
spec.resources             = "PickAndChoose/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
spec.swift_version         = "4.2"

  spec.description  = <<-DESC
This is a pretty simple UILabel that, when tapped, displays
a UIPicker to choose from, and fill in the Label.  You also
have the option of adding values to the datasource.
                   DESC

end
