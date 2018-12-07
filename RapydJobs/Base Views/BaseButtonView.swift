//
//  BaseButtonView.swift
//  RapydJobs
//
//  Created by Maroof Khan on 04/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class BaseButtonView: UIView {

    @IBOutlet weak var button: BaseButton!
    
    var vm: SubmitViewModel! {
        didSet {
            button.setup(title: vm.title)
            button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        if let view = Bundle.main.loadNibNamed("BaseButtonView", owner: self, options: nil)?.first as? UIView {
            embed(view: view)
        } else {
            fatalError("OH MY GOD! Itna tasty burger?!")
        }
    }
    
    @objc func submit() {
        vm.submission()
    }

}
