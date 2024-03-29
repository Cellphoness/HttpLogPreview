//
//  AppDelegate.swift
//  HttpLogPreview
//
//  Created by Cellphoness on 04/23/2021.
//  Copyright (c) 2021 Cellphoness. All rights reserved.
//

import UIKit

#if DEBUG
import HttpLogPreview
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let httpLogServerHostPort = 8077
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
#if DEBUG
        //SHow Log - http://your-phone-ip:8077
        HttpServerLogger.shared().startServer(UInt(httpLogServerHostPort))
#endif

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        // window 背景色为白色
        window?.backgroundColor = .white
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()

        #if DEBUG
        HttpServerLogger.shared().startServer(8989)
        #endif
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

