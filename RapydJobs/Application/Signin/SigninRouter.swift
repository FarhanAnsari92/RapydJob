//
//  SigninRouter.swift
//  RapydJobs
//
//  Created by Maroof Khan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class SigninRouter {
    
    lazy var signinService: SigninService = {
        let service = SigninService()
        service.delegate = self
        return service
    }()
    
    var viewModel: SigninViewModel!

    let window: UIWindow
    weak var coordinator: OnboardingCoordinator?
    
    init(window: UIWindow, coordinator: OnboardingCoordinator) {
        
        self.window = window
        self.coordinator = coordinator
        
        let signinViewController = FormViewController.getInstance()
        viewModel = SigninViewModel(service: signinService, coordinator: coordinator)
        
        signinViewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: signinViewController)
        navigationController.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        
        let back = UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate)

        navigationController.navigationBar.backIndicatorImage = back
        navigationController.navigationBar.backIndicatorTransitionMaskImage = back
        
        navigationController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationController.navigationBar.tintColor = .black
        
        window.setRootViewController(navigationController)
    }
    
    func proceedToHome() {
        coordinator?.proceedToHome()
    }
}

extension SigninRouter: SigninServiceDelegate {
    func signedin(token: Token<String>) {
        globalToken = token
        proceedToHome()
    }
    
    func failed(error: String) {
        print("FAILED")
        viewModel.delegate?.hideProgress()
        proceedToHome()
    }
    
    
}
