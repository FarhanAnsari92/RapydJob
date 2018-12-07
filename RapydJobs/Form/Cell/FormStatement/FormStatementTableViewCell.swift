//
//  FormStatementTableViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class FormStatementTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var statement: UILabel!
    @IBOutlet private weak var button: UIButton!
    private var viewModel: FormStatementViewModel! {
        didSet { update() }
    }
    
    func setup(with viewModel: FormStatementViewModel) {
        self.viewModel = viewModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup(button: button)
    }
    
    private func update() {
        statement.text = viewModel?.title
        button.setTitle(viewModel?.actionTitle, for: .normal)
    }
    
    private func setup(button: UIButton) {
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
    }
    
    @objc private func action(sender: UIButton) {
        viewModel?.action()
    }

}
