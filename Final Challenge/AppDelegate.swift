//
//  AppDelegate.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 14/05/18.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // MARK: - First launch boolean
    var hasLaunchedBefore: Bool {
        // It returns false if it's the app's first launch otherwise it returns true.
        let defaults = UserDefaults()
        guard defaults.bool(forKey: K.DefaultsKey.hasLaunchedBefore) else { defaults.set(true, forKey: K.DefaultsKey.hasLaunchedBefore); return false }

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // MARK: - Customization after application launch.

        if !self.hasLaunchedBefore {
        // Onboarding operations
            DatabaseInterface.shared.firstSetup()
        }
        
        CloudKitManager.shared.subscriptionSetup()
        application.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("Remote notifications device token: \(deviceToken)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("Remote notifications failed to register: \(error.localizedDescription)")
        debugPrint("Retry after 3 seconds.")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 3.0) {
            application.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // MARK: - A remote push notification arrives
        CloudKitManager.shared.didReceiveRemotePush(notification: userInfo)
        // FIXME: - Use the completion handler to inform if there's a background fetch or not.
        completionHandler(.newData)
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
