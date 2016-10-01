Steps to integrate LyftSDK  
1. Copy the LyftSDK folder to your project directory.  
2. Run pod init in your project directory (this creates a Podfile)  
3. Run pod install (this creates an xcworkspace)  
4. Open the xcworkspace  
5. Drag LyftSDK.xcodeproj into the xcworkspace at the top level.  
6. Add the following to your podfile:  
```
# At the top of your podfile:
workspace 'TestLyft.xcworkspace'
```
```
# In your app target:
pod "ModelMapper", :git => "https://github.com/Lyft/mapper", :branch => "swift-3.0"
```
```
# After your app target:
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
```
7. Run 'pod install' again to install and link ModelMapper.
8. Build the LyftAPI and LyftModels targets in Xcode.
    In the top left corner there are play and stop buttons. To the right of them there is a targets drop-down.
    Select the respective framework targets and press the play button to run them.
9. Click on your project's xcodeproj in the sidebar and select your app target.
10. Under 'Linked Frameworks and Libraries' click the '+' and add the LyftAPI and LyftModels targets.
11. Build your app. (Select your app target from the targets drop down first.) 
    If 'import LyftAPI' and 'import LyftModels' compile without errors, you should be good to go!
