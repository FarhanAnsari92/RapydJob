//
//  FormOptionsTableViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class FormOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var selectedOption: UILabel!
    private var border: AnimatableBottomBorder?
    private var viewModel: FormOptionsViewModel? {
        didSet { update() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        border = AnimatableBottomBorder(embedIn: contentView)
    }
    
    @IBAction func showOptions(sender: UIButton) {
        show(options: viewModel?.options)
    }
    
    func setup(with viewModel: FormOptionsViewModel) {
        self.viewModel = viewModel
    }
    
    private func update() {
        guard let viewModel = viewModel else {
            fatalError("`update` called without intialiazing/setting the viewModel!")
        }
        
        title.text = viewModel.title
        selectedOption.reactive.text <~ viewModel.selected.producer
    }
    
    private func show(options: [String]?) {
        
        if let options = options, options.isEmpty {
            viewModel?.persenter?.presentReleatedFields {
                self.viewModel?.selected.value = $0
            }
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        options?
            .compactMap { $0 }
            .map { option in
            return UIAlertAction(title: option, style: .default, handler: handler)
        }.forEach(alertController.addAction)
        viewModel?.persenter?.present(controller: alertController)
    }
    
    private func handler(action: UIAlertAction) {
        viewModel?.selected.value = action.title!
    }

}
