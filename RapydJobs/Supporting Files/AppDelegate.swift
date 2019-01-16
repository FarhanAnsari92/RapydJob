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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ReachabilityDelegate {

    var window: UIWindow?

    var apnsToken: String!
    
    let googleAPIKey = "AIzaSyBZA5rJQJNaRi8qq-16UaYnTB4tYTDUqiI"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //UIApplication.shared.statusBarView?.backgroundColor = Constants.Colors.primaryGreenColor
        
        
        
        Fabric.with([Crashlytics.self])
        
        //IQKeyboardManager.shared.enable = false
        
        AppRouter.shared.startLaunchFlow()
        
        /*
        // -- JOB OFFER RECEIVE - SEEKER SIDE
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = JobListSeekerViewController.getInstance()
        let navController = BaseNavigationViewController(rootViewController: vc)
        self.window?.setRootViewController(navController)
        self.window?.makeKeyAndVisible()
        */
        
        /*
        // -- SCHEDULE INTERVIEW - SEEKER SIDE
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ScheduleInterviewViewController.getInstance()
        let navController = BaseNavigationViewController(rootViewController: vc)
        self.window?.setRootViewController(navController)
        self.window?.makeKeyAndVisible()
        */
        
        /*
        // -- JOBOFFER ACCEPT - EMPLOYER SIDE
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let home = CardViewController.getInstance()
        home.cardFlow = .dashboard
        
        let hrVC = HRVC.getInstance()
        
        let sb = UIStoryboard(name: "HR", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ManageEmployeeViewControllerID") as! ManageEmployeeViewController
        
        let navController = BaseNavigationViewController()
        navController.setViewControllers([home,hrVC,vc], animated: true)
        
        self.window?.setRootViewController(navController)
        self.window?.makeKeyAndVisible()
         */
        
        /*
         // -- CHAT - BITH SIDES
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let home = CardViewController.getInstance()
        home.cardFlow = .dashboard
        
        let chatListVC = ChatListVC()
        
        let sb = UIStoryboard(name: "Chat", bundle: nil)
        let chatMessageVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
        chatMessageVC.conversationId = 16
        
        let navController = BaseNavigationViewController()
        navController.setViewControllers([home, chatListVC, chatMessageVC], animated: true)
        
        self.window?.setRootViewController(navController)
        self.window?.makeKeyAndVisible()
        */
        
        
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        
        SVProgressHUD.setDefaultMaskType(.custom)
        
        IQKeyboardManager.shared.enable = true        
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        //Push Notification
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
                
        }
        
        return true
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // Linkedin sdk handle redirect
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: nil, annotation: nil)
        }
        
        return false
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("*** token ***")
        print(self.apnsToken)
        print("*** token ***")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        guard let _ = UserContainer().user else {
            return
        }        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error.localizedDescription)") // called in background when tap notification/ foreground when receive notification
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
