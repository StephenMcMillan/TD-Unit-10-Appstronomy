/*
   -------------------
   Instruments Testing
   -------------------
 
   - MEMORY: Initially I viewed memory in the Xcode debug navigator. As i used my app on a real device I noticed that memory was not being de-allocated as i thought it should be. I decided to use the Leaks section in Instruments to check the memory usage of my app and as expected it was detecting leaks. I realised that this high memory from coming from the Rover Postcard section of my app so I ensured that all that there weren't any strong reference cycles by ensuring all view controllers in this process were deallocated appropriately. Once I ruled this out I suspected the large memory usage was coming from the many Mars rover images that were being loaded and I knew that the library I am using 'Kingfisher' caches downloaded images not just on the disk but in memory too. With this in mind I went to the docs of the framework and recognised that images are stored in memory cache for 5 mintues before they are removed from memory cahce. This is evident if you run the app, download mars rover photos and after 5 minutes memory usage will drop when the images are purged from memory cahce behind the scenes.
 
   - ENERGY: I could see that my app was using a high amount of energy but this was to be expected as the application will be downloading many images from the NASA API when the user is in the Mars Rover image picker view.
 */

//
//  AppDelegate.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 04/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

