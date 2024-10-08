[English](./README.md) | 简体中文

### 操作步骤

#### 1 在您项目中的 `Podfile` 文件里添加源及小程序依赖模块：

- ```objective-c
  source 'https://e.coding.net/tcmpp-work/tcmpp/tcmpp-repo.git'
  
  target 'YourTarget' do
       pod 'TCMPPSDK'
      
  end
  ```

  其中：

  - `YourTarget` 为您的项目需要引入 `TCMPPSDK` 的 target 的名字。

- Terminal `cd` 到 Podfile 文件所在目录，并执行 `pod install` 进行组件安装。

  ```shell
  $ pod install
  #注意：如果报 `Couldn't determine repo type for URL: 'https: //e.coding.net/tmf-work/tmf/tmf-repo.git':`错误，则需要在执行`pod install`前执行 `pod repo add specs https://e.coding.net/tcmpp-work/tcmpp/tcmpp-repo.git`
  
  
  ```

#### 2 SDK初始化

##### 2.1 配置文件获取

开发人员从管理平台获取对应App的配置文件，该配置文件是一个json文件，包含该App使用小程序平台的所有信息，将配置文件引入到项目中，并且做为资源设置在打包内容。

##### 2.2 配置信息设置

在工程的 `AppDelegate` 中的以下方法中，根据配置文件初始化一下TMFAppletConfig对象，并使用TMFAppletConfig初始化TCMPP小程序引擎。

参考代码：

```swift
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configItem = TMFAppletConfigManager.shared.getCurrentConfigItem();
        let filePath = Bundle.main.path(forResource: "tcmpp-ios-configurations", ofType: "json");
        if ((filePath) != nil){
            let config = TMAServerConfig(file: filePath!);
            TMFMiniAppSDKManager.sharedInstance().setConfiguration(config);
        }
        return true;
    }  

```



#### 3 打开小程序

打开小程序时，会先判断本地是否有缓存的小程序，如果没有，则会自动从远程服务器上下载小程序，然后打开。如果有缓存的小程序，则会先打开本地小程序，然后在后台校验服务器端是否有新版本。

如果有新版本，则下载新版小程序，下次打开时，就会使用新版小程序；如果没有新版本，则什么也不做。

```swift
let appId = "mini program id"
TMFMiniAppSDKManager.sharedInstance().startUpMiniApp(withAppID: info.appId, parentVC: self) { (error) in
	self.showErrorInfo(error)
}
```

