//
//  AppDelegate.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var router: Router?
    var localRecipesEntity: LocalRecipesCollectionProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.localRecipesEntity = LocalRecipesCollection.shared
        self.window = UIWindow()
        self.window?.backgroundColor = .white
        self.window?.rootViewController = Router.shared.navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    /// Method that is called when app is going to resign, saves info about current recipes to
    /// persistent storage of core data
    ///
    /// - Parameter application: application object
    func applicationWillResignActive(_ application: UIApplication) {
        let coreService = CoreDataService()
        guard let recipes = self.localRecipesEntity else {
            return
        }
        coreService.saveRecipes(recipes.localRecipes.dict)
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

