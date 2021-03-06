![Bagel](https://github.com/yagiz/Bagel/blob/pre/assets/header.png?raw=true)

Bagel is a little native iOS network sniffer. It's not a proxy debugger so you don't have to mess around with certificates, proxy settings etc. As long as your iOS devices and your Mac are in the same network, you can view the network traffic of your apps seperated by the devices. 

Bagel iOS sniffes the ```NSURLSession``` and ```NSURLConnection``` delegate classes and broadcast requests to the Bagel macOS by using Bounjour protocol.

### Preview
![Bagel](https://github.com/yagiz/Bagel/blob/pre/assets/screenshot.png?raw=true)
If you are here for the macOS client, you can download it from here.
### Installation
To connect your app you need to install Bagel iOS in your app projects and download macOS client to view network traffic.
#### CocoaPods
```sh
pod 'Bagel'
```
#### Manually
Just download or clone the repo and move ```Bagel.framework``` into your project.

### Usage
Most basic usage is to start Bagel iOS before any operation that sends requests. 
```swift
//import Bagel
Bagel.shared().start()
```

###  Configuring Bagel
By default, Bagel gets your project name and device information. Desktop client uses these informations to seperate projects and devices. You can configure these if you wish:
```swift
let bagelConfig = BagelConfiguration()

bagelConfig.project.projectName = "Custom Project Name"
bagelConfig.device.deviceName = "Custom Device Name"
bagelConfig.device.deviceDescription = "Custom Device Description"

Bagel.shared().startWithConfiguration(bagelConfig)
```
Bagel framework communicates with the desktop client by using Bounjour protocol. You can also configure these Netservice parameters. Default values are:

```swift
let bagelConfig = BagelConfiguration()

bagelConfig.netservicePort = 43434
bagelConfig.netserviceDomain = "_Bagel._tcp"
bagelConfig.netserviceType = ""
bagelConfig.netserviceName = ""

Bagel.shared().startWithConfiguration(bagelConfig)
```
If you change Netservice parameters in your app, you should also change them on desktop client.
###  Releasing
Bagel by default is disabled in release version. You can however enable it by opening your app with a deep link. This way, you can still view the network traffic of your submitted app.
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

	Bagel.shared().appWillOpenURL(url)
	
}
```
If the host of your URL is ```bagel``` then Bagel is enabled. Here is a typical example URL:
```swift
yourproject://bagel
```
License
----
Apache