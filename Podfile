# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'
workspace 'TestLyft.xcworkspace'

target 'TestLyft' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    pod "PromiseKit", :git => "https://github.com/mxcl/PromiseKit", :branch => "swift-3.0"
    pod "ModelMapper", :git => "https://github.com/Lyft/mapper", :branch => "swift-3.0"
end

target 'LyftAPI' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    project 'LyftSDK/LyftSDK.xcodeproj'

    # Pods for TestLyft

    pod "ModelMapper", :git => "https://github.com/Lyft/mapper", :branch => "swift-3.0"
end

target 'LyftModels' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    project 'LyftSDK/LyftSDK.xcodeproj'

    # Pods for TestLyft

    pod "ModelMapper", :git => "https://github.com/Lyft/mapper", :branch => "swift-3.0"
end
