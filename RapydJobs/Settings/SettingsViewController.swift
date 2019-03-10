//
//  SettingsViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JGProgressHUD

class SettingsViewController: BaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    let settingsArry = ["Terms & Conditions","Privacy Policy","Share App","Sign Out"]
    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()

        self.title = "Settings"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 80
        self.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = self.settingsArry[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = Bundle.main.loadNibNamed("SettingsHeaderView", owner: self, options: nil)?.first as? SettingsHeaderView else {
            return UIView()
        }
        view.titleLabel.text = "ABOUT APP"
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // For Testing Purpose.
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            self.shareAppTapped()
        case 3:
            AlertService.shared.alert(in: self, "Are you sure you want to Sign Out?") {
                self.performSignOut()
            }            
        default:
            break
        }
    }
    
    func shareAppTapped() {
        let text = "Hey there, check out this awesome app! - Download RapydJobs now! 🙌"
        let myWebsite = NSURL(string:"https://google.com") ?? NSURL()
        let textToShare = [text, myWebsite] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func performSignOut() {
        hud.show(in: view)
        _ = APIClient.callAPI(request: .logout, onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
            UserDefaults.standard.removeObject(forKey: "USER_TOKEN")
            UserDefaults.standard.removeObject(forKey: "APP_USER")
            AppContainer.shared.user.save(isLogin: false)
            EditProfileFlowManager.shared().isEditProfile = false
            EditProfileFlowManager.shared().isHomeScreen = true
            let name = Storyboards.Login.name()
            let sb = UIStoryboard(name: name, bundle: nil)
            let vc = sb.instantiateInitialViewController()!
            self.present(vc, animated: true, completion: nil)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
        }
        
    }
}

extension SettingsViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.settings.rawValue
    }
}
