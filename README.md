# HttpLogPreview

[![CI Status](https://img.shields.io/travis/Cellphoness/HttpLogPreview.svg?style=flat)](https://travis-ci.org/Cellphoness/HttpLogPreview)
[![Version](https://img.shields.io/cocoapods/v/HttpLogPreview.svg?style=flat)](https://cocoapods.org/pods/HttpLogPreview)
[![License](https://img.shields.io/cocoapods/l/HttpLogPreview.svg?style=flat)](https://cocoapods.org/pods/HttpLogPreview)
[![Platform](https://img.shields.io/cocoapods/p/HttpLogPreview.svg?style=flat)](https://cocoapods.org/pods/HttpLogPreview)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

To Copy following files to your project to customize
* Define.swift
* LogPreviewManager.swift
* Lock.kit

use
``` swift
HttpServerLogger.shared().startServer()
``` 
to start your server by default 8080 port
``` swift
#if DEBUG
import HttpLogPreview
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        #if DEBUG
        HttpServerLogger.shared().startServer(8989)
        #endif
        
        return true
    }
}
```

## More Usage

more usage for LogPreviewManager.swift
can be seen in Example Project ViewController.swift

## Installation

HttpLogPreview is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HttpLogPreview'
```

## Author

Cellphoness, 1026366384@qq.com

## License

HttpLogPreview is available under the MIT license. See the LICENSE file for more info.
