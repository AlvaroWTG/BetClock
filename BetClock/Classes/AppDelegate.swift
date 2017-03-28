//
//  AppDelegate.swift
//  BetClock
//
//  Created by WebToGo on 3/24/17.
//  Copyright © 2017 Alvaro GMH. All rights reserved.
//

import UIKit
import UserNotifications

struct Colors { // Constants for color definitions used in the app
    static let Color147855 = UIColor.init(red: 20/255, green: 120/255, blue: 85/255, alpha: 1)
    static let ColorF0F0F0 = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    static let Color3A3A3A = UIColor.init(red: 56/255, green: 56/255, blue: 56/255, alpha: 1)
}

struct Size { // Constants for screen size used in the app
    static let SizeIphone5 = 160.0 as CGFloat
    static let SizeIphone6 = 187.0 as CGFloat
    static let SizeIphone6plus = 207.0 as CGFloat
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    /** Property that represents the window of the app */
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Customize the navigation and tab bar appearances
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UITabBar.appearance().tintColor = Colors.Color147855
        UINavigationBar.appearance().tintColor = UIColor.white
        requestNotificationsAuthorization()

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

    //MARK: - Inherited functions from UILocalNotification delegate

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if application.applicationState == .active {
            UIAlertView.init(title: "BetClock", message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
        }
        application.applicationIconBadgeNumber = 0;
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier { // Determine the user action
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound]) // Play sound and show alert to the user
    }

    //MARK: - Auxiliary functions

    func requestNotificationsAuthorization() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound]
            center.delegate = self
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    NSLog("[UNNotification] Error! Something went wrong. Error 500 - %@", error?.localizedDescription ?? "unknown")
                }
            }
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized { // Notifications not allowed
                    NSLog("[UNNotification] Log: Notifications are not currently allowed")
                }
            }
        }
    }
}

