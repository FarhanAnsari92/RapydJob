//
//  FormActionTableViewCell.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import UIKit

class FormActionTableViewCell: UITableViewCell {
    @IBOutlet private weak var button: UIButton!
    private var viewModel: FormActionViewModel? {
        didSet { update() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(button: button)
    }
    
    func setup(with viewModel: FormActionViewModel) {
        self.viewModel = viewModel
    }
    
    private func setup(button: UIButton) {
        button.layer.masksToBounds = true
        
        addGradient(to: button)
        button.layer.cornerRadius = button.bounds.midY
        
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
    }
    
    private func addGradient(to button: UIButton) {
        
        let gradient = CAGradientLayer()
        gradient.frame = button.bounds
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1.0, y: 1.0)
        gradient.colors = [Constants.Colors.buttonGradientStart.cgColor, Constants.Colors.buttonGradientEnd.cgColor]
        
        button.layer.addSublayer(gradient)
    }
    
    private func update() {
        button.setTitle(viewModel?.title, for: .normal)
    }
    
    @objc private func action(sender: UIButton) {
        viewModel?.action()
    }
}
