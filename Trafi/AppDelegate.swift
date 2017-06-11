//
//  AppDelegate.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-04.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(shouldPerformActionFor(shortcutItem: shortcutItem))
    }
    
    private func shouldPerformActionFor(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(identifier: shortcutType) else {
            return false
        }
        return selectViewControllerFor(shortcutIdentifier: shortcutIdentifier)
    }
    
    private func selectViewControllerFor(shortcutIdentifier: ShortcutIdentifier) -> Bool {
        
        switch shortcutIdentifier {
        case .OpenCompetitions:
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let competititonsViewController: CompetitionTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "competitions") as! CompetitionTableViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = competititonsViewController
            self.window?.makeKeyAndVisible()
            return true
        }
    }


}

