//
//  FormPinCodeTableViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//
//
import UIKit
//import PinCodeTextField

class FormPinCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pincodeField: UITextField! {
        didSet {
            pincodeField.delegate = self
        }
    }
    private var border: AnimatableBottomBorder?
    private var viewModel: FormPinCodeViewModel!
    
    func setup(with viewModel: FormPinCodeViewModel) {
        self.viewModel = viewModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        border = AnimatableBottomBorder(embedIn: contentView)
    }
}

extension FormPinCodeTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border?.animate()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        border?.deanimate()
    }
}
