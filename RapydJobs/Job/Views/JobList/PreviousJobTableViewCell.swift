//
//  PreviousJobTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class PreviousJobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var repeatJob: UIButton!{
        didSet {
            actionStyle(repeatJob, UIImage(named: "ic_interviews")!)
            repeatJob.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var deleteJob: UIButton!{
        didSet {
            actionStyle(deleteJob, UIImage(named: "ic_cross_big")!) //ic_delete
            deleteJob.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    
    var repeatJobCompletion: (() -> Void)?
    var deleteJobCompletion: (() -> Void)?

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

        // Configure the view for the selected state
    }
    
    @IBAction func repeatJob(_ sender: UIButton) {
        self.repeatJobCompletion?()
    }
    
    @IBAction func deleteJob(_ sender: UIButton) {
        self.deleteJobCompletion?()
    }
    
}
