//
//  BaseFieldView.swift
//  RapydJobs
//
//  Created by Maroof Khan on 30/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class BaseFieldView: UIView {
    
    private enum Constant {
        static let title = Constants.Fonts.fieldTitle
        static let textField = Constants.Fonts.fieldTextField
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bar: AnimatableBar!
    
    var viewModel: InputViewModel! {
        didSet {
            title.text = viewModel.title
            textField.placeholder = viewModel.placeholder
            textField.keyboardType = viewModel.keyboard
            
            viewModel.value <~ textField.reactive.continuousTextValues.skipNil()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        embed(view: loadNib()!)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        embed(view: loadNib()!)
        setup()
    }
    
    private func loadNib() -> UIView? {
        return Bundle.main.loadNibNamed("BaseFieldView", owner: self, options: nil)?.first as? UIView
    }
    
    private func setup() {
        title.font = Constant.title
        textField.font = Constant.textField
    }
}

extension BaseFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bar.animate()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bar.deanimate()
    }
}
