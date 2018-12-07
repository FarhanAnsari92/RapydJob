//
//  BaseFieldSelectableView.swift
//  RapydJobs
//
//  Created by Maroof Khan on 30/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BaseFieldSelectableView: UIView {
    
    private enum Constant {
        static let title = Constants.Fonts.fieldTitle
        static let selection = Constants.Fonts.fieldTextField
    }
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var selection: UILabel!
    @IBOutlet private weak var selectionButton: UIButton!
    
    private weak var delegate: SelectionDelegate?
    private var border: AnimatableBorder?
    
    var vm: SelectableInputViewModel? {
        didSet {
            title.text = vm?.title
            selection.reactive.text <~ vm!.value.producer
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        setup()
    }
    
    private func loadNib() {
        if let view = Bundle.main.loadNibNamed("BaseFieldSelectableView", owner: self, options: nil)?.first as? UIView {
            embed(view: view)
        } else {
            fatalError("OH MY GOD! Itna tasty burger?!")
        }
    }
    
    private func setup() {
        
        border = AnimatableBorder(embedIn: self, height: 1.0, color: .lightGray)
        
        title.font = Constant.title
        title.textColor = .lightGray
        
        selection.font = Constant.selection
        
        selectionButton.setTitle(nil, for: .normal)
        selectionButton.addTarget(self, action: #selector(showSelection), for: .touchUpInside)
    }
    
    @objc private func showSelection() {
        
        if vm != nil {
            if vm!.openRelatedFields {
                
                vm!.presenter?.presentOptions {
                    self.vm?.value.value = $0
                }
                
            } else {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let actions = vm!.options.map{
                    UIAlertAction(title: $0, style: .default, handler: {
                        self.vm!.value.value = $0.title!
                    })
                }
                
                actions.forEach(alert.addAction)
                
                vm!.presenter?.present(alert: alert)
            }
        }
    }
    
    func update(selected: String) {
        if vm?.value.value != nil {
            vm!.value.value = selected
        }
    }
    
    func update(title: String?, selected: String, delegate: SelectionDelegate) {
        self.title.text = title
        self.delegate = delegate
        self.update(selected: selected)
    }

}
