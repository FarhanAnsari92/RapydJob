//
//  SignedContractTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/4/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class SignedContractTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var contractImage: UIImageView!
    @IBOutlet weak var contractTitle: UILabel!
    @IBOutlet weak var signedBy: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        print(contractImage.frame.height / 2)
        self.contractImage.layer.cornerRadius = contractImage.frame.height / 2
        
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
    
    func updateData(_ data: SignedContract) {
        self.contractImage.setImageWithName(data.signedBy?.profileImage ?? "")
        self.signedBy.text = data.signedBy?.userName ?? ""
        self.contractTitle.text = data.file ?? ""
    }
    
}
