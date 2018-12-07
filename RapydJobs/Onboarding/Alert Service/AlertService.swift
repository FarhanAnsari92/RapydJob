//
//  AlertService.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit

struct AlertService {
    
    private init () {}
    
    static let shared = AlertService()
    
    func alert(in vc: UIViewController, _ message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true)
        }))
      
        vc.present(alert, animated: true, completion: nil)
    }
}
