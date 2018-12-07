//
//  AppDelegate.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import LinkedinSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ReachabilityDelegate {

    var window: UIWindow?

    let googleAPIKey = "AIzaSyBZA5rJQJNaRi8qq-16UaYnTB4tYTDUqiI"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //UIApplication.shared.statusBarView?.backgroundColor = Constants.Colors.primaryGreenColor
        
        
        
        Fabric.with([Crashlytics.self])
        
        //IQKeyboardManager.shared.enable = false
        
        AppRouter.shared.startLaunchFlow()
        
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        
        SVProgressHUD.setDefaultMaskType(.custom)
        
        IQKeyboardManager.shared.enable = true        
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // Linkedin sdk handle redirect
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: nil, annotation: nil)
        }
        
        return false
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketService.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        REACHABILITY_HELPER.unregisterDelegate(self)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        REACHABILITY_HELPER.registerDelegate(self)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "RapydJobs")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func reachabilityDidUpdate(_ status: Bool) {
        print("-------- App Delegate ---------")
        print(status)
        print("-------- App Delegate ---------")
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
