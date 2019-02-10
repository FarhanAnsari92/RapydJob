//
//  AppRouter.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import UIKit

class AppRouter {
    
    static let shared: AppRouter = .init()
    
    let container: AppContainer
    let window: UIWindow
    
    init(window: UIWindow = .init(frame: UIScreen.main.bounds), container: AppContainer = .shared) {
        self.window = window
        self.container = container
        REACHABILITY_HELPER.setupReachability(self.window)
    }
    
    func startLaunchFlow() {
        
        /// FIRST, WE NEED A BASE.. YOU KNOW.. FOR STUFF
        /// WE CAN CUSTOMIZE IT ONCE WE NEED STUFF IN THE
        window.makeKeyAndVisible()
        
        if let _ = UserContainer().user, AppContainer.shared.user.isLogin {
            proceed()
        } else {
            signin()
            
//            let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
//            let vc = sb.instantiateInitialViewController()!
//            window.setRootViewController(vc)
            
        }
        
    }
    
    func startSignup() -> UIViewController {
        let form: FormViewController = .getInstance()
        //form.viewModel = SignupViewModel(coordinator: self)
        
        return form
    }
    
    func startSignin() -> UIViewController {
        let form: FormViewController = .getInstance()
        //form.viewModel = SigninViewModel(coordinator: self)
        
        return form
    }
    
    func startRecovery() {
    }
}

extension AppRouter: UserFlowCoordinator {
    
    var signupWindow: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    
    func signup() {
        
        let navigationController = BaseNavigationViewController(rootViewController: startSignup())
        navigationController.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        
        let back = UIImage(named: "ic_back")
        navigationController.navigationBar.backIndicatorImage = back
        navigationController.navigationBar.backIndicatorTransitionMaskImage = back
        navigationController.navigationBar.tintColor = .black
        
        window.setRootViewController(navigationController)
    }
    
    func signin() {
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        window.setRootViewController(vc)
    }
    
    func forgotPass() {
        _ = BaseNavigationViewController(rootViewController: UIViewController())
        //let _ = PasswordRecoveryRouter(window: window)
    }
    
    func proceed() {
        let home = CardViewController.getInstance()
        home.cardFlow = .dashboard
        let navController = BaseNavigationViewController(rootViewController: home)
        window.setRootViewController(navController)
    }
}

protocol UserFlowCoordinator: class {
    func signup()
    func signin()
    func forgotPass()
    func proceed()
    var signupWindow: UINavigationController? { get }
}
