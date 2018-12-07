//
//  SignupRouter.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import UIKit

class SignupRouter {
    
    private lazy var signupService: SignupService = {
        let signupService = SignupService()
        signupService.delegate = self
        return signupService
    }()
    
    private lazy var employerOnboardingService: EmployerOnboardingService = {
       return EmployerOnboardingService(delegate: self)
    }()
    
    let window: UIWindow
    var navigationController: UINavigationController?
    weak var coordinator: OnboardingCoordinator?
    var signupViewModel: SignupViewModel!
    
    init(window: UIWindow, coordinator: OnboardingCoordinator?) {
        self.window = window
        self.coordinator = coordinator
        
        let signupViewController = FormViewController.getInstance()
        signupViewModel = SignupViewModel(service: signupService, router: self, presenter: signupViewController, coordinator: coordinator)
        
        signupViewController.viewModel = signupViewModel
        
        let navigationController = UINavigationController(rootViewController: signupViewController)
        navigationController.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        
        let back = UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate)
        
        navigationController.navigationBar.backIndicatorImage = back
        navigationController.navigationBar.backIndicatorTransitionMaskImage = back
        
        navigationController.navigationBar.tintColor = .black
        
        window.setRootViewController(navigationController)
        self.navigationController = navigationController
    }
    
    func employerSignup(username: String, email: String, password: String) {
        signupService.signup(username: username, email: email, password: password, confirmPassword: password, accountType: .employer)
    }
    
    func proceedToEmployerInfo() {
        let viewModel: EmployerInfoViewModel = .init(router: self)
        let controller: FormViewController = .getInstance()
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func employerUpdateInfo(organization: String, registration: String, website: String, contact: String) {
        employerOnboardingService.updateEmployerInfo(organization: organization, registration: registration, website: website, contact: contact)
    }
    
    func proceedToVerifyPhone() {
        let viewModel: EmployerVerifyPhoneViewModel = .init(router: self)
        let controller: FormViewController = .getInstance()
        controller.viewModel = viewModel
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func proceedToEmployerAddressInfo() {
        let viewModel: EmployerAddressViewModel = .init(router: self)
        let controller: FormViewController = .getInstance()
        controller.viewModel = viewModel
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func employerUpdateAddressInfo(address: String, floor: String?, postal: String) {
        employerOnboardingService.updateEmployerAddress(address: address, floor: floor, postal: postal)
    }
    
    func proceedToJobSeekerInfo() {
        let controller: FormViewController = .getInstance()
        let viewModel: JobSeekerInfoViewModel = .init(router: self, presenter: controller)
       
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func proceedToJobseekerVerifyPhone() {
        let viewModel: JobSeekerVerifyPhoneViewModel = .init(router: self)
        let controller: FormViewController = .getInstance()
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func proceedToJobseekerEducation() {
        let viewModel: JobSeekerEducationViewModel = .init(router: self, education: [1999, 2001, 2039])
        let controller: FormViewController = .getInstance()
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func proceedToJobseekerExperience() {
        let viewModel: JobseekerExperienceViewModel = .init(router: self, experiences: [1999, 1890])
        let controller: FormViewController = .getInstance()
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func proceedToJobseekerLanguage() {
        let viewModel: JobseekerLanguagesViewModel = .init(router: self, languages: [3, 4])
        let controller: FormViewController = .getInstance()
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func proceedToHome() {
        coordinator?.proceedToHome()
    }
    
}

extension SignupRouter: SignupServiceDelegate {
    func signedup(token: Token<String>, account: AccountType) {
        globalToken = token
        if account == .employer {
            self.proceedToEmployerInfo()
        } else {
            proceedToJobSeekerInfo()
        }
    }
    
    func failed(error: String) {
        
        //TODO: error handling
        signupViewModel.delegate?.hideProgress()
    }
    
    
}

extension SignupRouter: EmployerOnboardingServiceDelegate {
    func proceedToPhoneVerification() {
        signupViewModel.delegate?.hideProgress()
        proceedToVerifyPhone()
    }
    
    func proceedToLogoUpload() {
        signupViewModel.delegate?.hideProgress()
        proceedToHome()
    }
    
    func proceed() {
    }
    
    func failuer(error: NetworkError) {
        signupViewModel.delegate?.hideProgress()
        proceedToVerifyPhone()
    }
}
