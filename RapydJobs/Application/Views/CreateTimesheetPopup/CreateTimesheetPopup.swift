//
//  CreateTimesheetPopup.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 3/1/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit

class CreateTimesheetPopup: UIView {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtFieldParent: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    
    let maxLength = 6
    var selectedWeeks: [[String:Any]] = [[String:Any]]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    var completion: (([String:Any]) -> Void)?
    
    init?(week: [[String:Any]], completion handler:(([String:Any]) ->Void)?) {
        
        let window = UIApplication.shared.keyWindow!
        
        super.init(frame: window.bounds)
        self.frame = window.bounds
        
        let nibName = "CreateTimesheetPopup"
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        view.frame = self.frame
        self.addSubview(view)
        
        
        self.selectedWeeks = week
        self.completion = handler
        self.parentView.layer.cornerRadius = 10
        self.parentView.clipsToBounds = true
        self.parentView.layer.masksToBounds = true
        self.txtFieldParent.layer.cornerRadius = self.txtFieldParent.frame.height / 2
        self.txtField.delegate = self
        self.txtField.addTarget(self, action: #selector(self.textFieldEditingDidChange(sender:)), for: UIControlEvents.editingChanged)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            window.addSubview(self)
        })
        
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        self.completion?(["hourly_rate": self.txtField.text])
    
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.removeFromSuperview()
        })
        
    }
    
    @IBAction func dismiss() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.removeFromSuperview()
        })
    }
    
    @objc func textFieldEditingDidChange(sender: UITextField) {
        let amount = Double(sender.text ?? "0.0") ?? 0.0
        
        var totalTime = 0.0
        for item in self.selectedWeeks {
            let difference = item["difference"] as? Double ?? 0.0
            totalTime = totalTime + difference
        }
        
        let ttlAmount = totalTime * amount
        let totalAmount = Double(round(100*ttlAmount)/100)
        self.totalAmount.text = "Total Amount: £\(totalAmount)"
    }

}

extension CreateTimesheetPopup: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        
    }
    
}
