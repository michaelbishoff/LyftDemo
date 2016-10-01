# Lyft iOS SDK **Preview**
Setup: [Hard Mode](https://github.com/michaelbishoff/LyftDemo/tree/master/LyftSDK) (Integrate SDK into existing project)  

Setup: Easy Mode (Start with a clean projec that only includes the SDK)  
1. `git clone https://github.com/michaelbishoff/LyftDemo.git`  
2. `git checkout easy-mode`  
3. `pod install`  
4. `open TestLyft.xcworkspace` Convert/Next/Save/Unlock anything that pops up (it will fail at the end)  
5. Build LyftModels  
6. Build LyftAPI  
7. [Create a Lyft API App](https://www.lyft.com/developers/manage)  
8. Copy your `token` and `client_id` to the file `TestLyft/Keys.swift`  
9. Use the TestLyft project in Xcode as your main project  
