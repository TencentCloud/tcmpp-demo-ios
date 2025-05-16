English | [简体中文](./README_ZH.md)

Objective-C | [Swift](./Swift/README.md)

### Steps

#### 1 Add source and mini program dependency modules to the `Podfile` file in your project:

- ```objective-c
  source 'https://e.coding.net/tcmpp-work/tcmpp/tcmpp-repo.git'
  
  target 'YourTarget' do
       pod 'TCMPPSDK'
      
  end
  ```

  In：

  - `YourTarget` is the name of the target that needs to introduce `TCMPPSDK` into your project.

- Terminal `cd` to the directory where the Podfile file is located, and execute `pod install` to install the component.

  ```shell
  $ pod install
  #Note: If an error of `Couldn't determine repo type for URL: 'https://e.coding.net/tcmpp-work/tcmpp/tcmpp-repo.git':` is reported, you need to execute `pod install` Before executing `pod repo add specs https://e.coding.net/tcmpp-work/tcmpp/tcmpp-repo.git`
  
  ```

#### 2 SDK initialization

##### 2.1 Configuration file acquisition

The developer obtains the configuration file of the corresponding App from the management platform. The configuration file is a json file that contains all the information about the app's use of the mini program platform. The configuration file is introduced into the project and is set as a resource in the packaged content.

##### 2.2 Configuration information settings

In the following method in the project's `AppDelegate`, initialize the TMFAppletConfig object according to the configuration file, and use TMFAppletConfig to initialize the TCMPP applet engine.

Reference Code:

```objective-c
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// Code that needs to be added to the App--start
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tcsas-ios-configurations" ofType:@"json"];
    if(filePath) {
       TMAServerConfig *config  = [[TMAServerConfig alloc] initWithFile:filePath];
       [[TMFMiniAppSDKManager sharedInstance] setConfiguration:config];
    }    
    // Code that needs to be added to the App--end
    
    return YES;
}    

```



#### 3 Open the mini program

When opening a mini program, it will first determine whether there is a cached mini program locally. If not, it will automatically download the mini program from the remote server and then open it. If there is a cached applet, the local applet will be opened first, and then it will be checked in the background whether there is a new version on the server side.

If there is a new version, download the new version of the mini program, and the new version of the mini program will be used the next time you open it; if there is no new version, do nothing.

```objective-c
NSString *appId = @"mini program id";
// open the mini program   
[[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithAppID:appId parentVC:self completion:^(NSError *_Nullable error) {
 		NSLog(@"open applet error:%@", error);
      }];
```

