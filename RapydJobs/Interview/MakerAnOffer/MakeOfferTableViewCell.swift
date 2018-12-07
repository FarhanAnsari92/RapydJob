//
//  MakeOfferTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/2/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class MakeOfferTableViewCell: UITableViewCell { //ShdaowBaseTableViewCell
    
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var contractTitle: UILabel!
    @IBOutlet weak var parentVu: UIView!
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.fileImage.contentMode = .center
        self.fileImage.contentMode = .scaleAspectFit
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        parentVu.backgroundColor = .white
        parentVu.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0.1176470588, alpha: 1)
        parentVu.layer.shadowRadius = 4
        parentVu.layer.shadowOpacity = 0.3
        parentVu.layer.shadowOffset = CGSize(width: -2, height: 0.5)
        parentVu.translatesAutoresizingMaskIntoConstraints = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(date: Contract?) {
        guard let contract = date else {
            return
        }
        self.contractTitle.text = contract.fileName
        self.fileImage.image = UIImage(named: "ic_document")
        
    }
    
}
