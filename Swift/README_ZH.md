[English](./README.md) | 简体中文

### 操作步骤

#### 1 使用 Swift Package Manager (SPM) 添加 SDK 依赖：

- 在 Xcode 中，选择 `File` > `Add Packages`。

- 在搜索窗口中输入以下 URL：

  ```
  https://github.com/TCMPP-Team/TCMPPSDK.git
  ```

- 选择版本规则（建议使用 `Up to Next Major Version`），然后点击 `Add Package` 按钮。

- 添加 SDK 后，需要在 Xcode 中进行以下项目设置：

  - 选择 `Build Settings` > `Linking` > `Other Linker Flags`，然后添加 `-ObjC`。

  - 根据需要添加其他扩展库，具体请参考 [SDK 快速集成](https://www.tencentcloud.com/zh/document/product/1219/61438) 文档中的说明。

#### 2 SDK初始化

##### 2.1 配置文件获取

开发人员从管理平台获取对应App的配置文件，该配置文件是一个json文件，包含该App使用小程序平台的所有信息，将配置文件引入到项目中，并且做为资源设置在打包内容。

- 从小程序控制台获取 `tcsas-ios-configurations.json` 配置文件。

- 将该文件添加到项目中，确保 iOS 工程的 `bundleId` 与控制台中配置的 `bundleId` 保持一致。

##### 2.2 配置信息设置

在工程的 `AppDelegate` 中引入头文件，并根据配置文件初始化 SDK。

参考代码：

```swift
import TCMPPSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 需要添加至App中的代码--start
    if let filePath = Bundle.main.path(forResource: "tcsas-ios-configurations", ofType: "json") {
        let config = TMAServerConfig(file: filePath)
        TMFMiniAppSDKManager.sharedInstance().setConfiguration(config)
    }
    // 需要添加至App中的代码--end
    
    return true
}
```



#### 3 打开小程序

打开小程序时，会先判断本地是否有缓存的小程序，如果没有，则会自动从远程服务器上下载小程序，然后打开。如果有缓存的小程序，则会先打开本地小程序，然后在后台校验服务器端是否有新版本。

如果有新版本，则下载新版小程序，下次打开时，就会使用新版小程序；如果没有新版本，则什么也不做。

```swift
let appId = "小程序id"
// 打开小程序
TMFMiniAppSDKManager.sharedInstance().startUpMiniApp(withAppID: appId, parentVC: self) { (error) in
    if let error = error {
        print("打开小程序出错：\(error)")
    }
}
```

