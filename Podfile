
platform :ios, '8.0'
inhibit_all_warnings! 
use_frameworks!

target 'FirstSwiftApp' do
    pod 'Alamofire'
    pod 'SwiftyJSON'
	pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'RxSwift'
                target.build_configurations.each do |config|
                    if config.name == 'Debug'
                        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                    end
                end
            end
        end
    end
end

target 'FirstSwiftAppTests' do

	pod 'RxBlocking'
    pod 'RxTest'

end





