//
//  FormFieldTableViewCell.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Validator

class FormFieldTableViewCell: UITableViewCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    private var border: AnimatableBottomBorder?
    private var viewModel: FormFieldViewModel? {
        didSet { update() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        border = AnimatableBottomBorder(embedIn: contentView)
    }
    
    func setup(with viewModel: FormFieldViewModel) {
        self.viewModel = viewModel
        
        textField.reactive.continuousTextValues.skipNil().observeValues { text in
            viewModel.validator(text) ? self.border?.colorIt() : self.border?.colorIt(with: .red)
        }
    }
    
    private func update() {
        guard let viewModel = viewModel else {
            fatalError("`update` called without intialiazing/setting the viewModel!")
        }
        
        viewModel.value <~ textField.reactive.continuousTextValues.skipNil()
        
        title.text = viewModel.title
        
        textField.isSecureTextEntry = viewModel.secure
        textField.keyboardType = viewModel.keyboard
    }
    
}

extension FormFieldTableViewCell: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        border?.animate()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text?.isEmpty ?? false ? border?.deanimate() : ()
    }
}
