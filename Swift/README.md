English | [简体中文](./README_ZH.md)

### Steps

#### 1 Add SDK dependency using Swift Package Manager (SPM):

- In Xcode, select `File` > `Add Packages`.

- In the search window, enter the following URL:

  ```
  https://github.com/TCMPP-Team/TCMPPSDK.git
  ```

- Select the version rule (recommended: `Up to Next Major Version`), then click the `Add Package` button.

- After adding the SDK, you need to configure the following project settings in Xcode:

  - Select `Build Settings` > `Linking` > `Other Linker Flags`, then add `-ObjC`.

  - Add other extension libraries as needed. For details, please refer to the [SDK Quick Integration](https://www.tencentcloud.com/zh/document/product/1219/61438) documentation.

#### 2 SDK initialization

##### 2.1 Configuration file acquisition

The developer obtains the configuration file of the corresponding App from the management platform. The configuration file is a json file that contains all the information about the app's use of the mini program platform. The configuration file is introduced into the project and is set as a resource in the packaged content.

- Get the `tcsas-ios-configurations.json` configuration file from the mini program console.

- Add this file to the project, ensuring that the iOS project's `bundleId` matches the `bundleId` configured in the console.

##### 2.2 Configuration information settings

In the project's `AppDelegate`, import the header file and initialize the SDK according to the configuration file.

Reference Code:

```swift
import TCMPPSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Code that needs to be added to the App--start
    if let filePath = Bundle.main.path(forResource: "tcsas-ios-configurations", ofType: "json") {
        let config = TMAServerConfig(file: filePath)
        TMFMiniAppSDKManager.sharedInstance().setConfiguration(config)
    }
    // Code that needs to be added to the App--end
    
    return true
}
```



#### 3 Open the mini program

When opening a mini program, it will first determine whether there is a cached mini program locally. If not, it will automatically download the mini program from the remote server and then open it. If there is a cached applet, the local applet will be opened first, and then it will be checked in the background whether there is a new version on the server side.

If there is a new version, download the new version of the mini program, and the new version of the mini program will be used the next time you open it; if there is no new version, do nothing.

```swift
let appId = "mini program id"
// open the mini program
TMFMiniAppSDKManager.sharedInstance().startUpMiniApp(withAppID: appId, parentVC: self) { (error) in
    if let error = error {
        print("open applet error: \(error)")
    }
}
```

