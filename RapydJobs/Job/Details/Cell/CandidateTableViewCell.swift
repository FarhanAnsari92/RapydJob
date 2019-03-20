//
//  CandidateTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 3/20/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit

class CandidateTableViewCell: ShdaowBaseTableViewCell {
    
    @IBOutlet weak var candidateName: UILabel!
    @IBOutlet weak var candidateImage: UIImageView!

    @IBOutlet weak var interviewBtn: UIButton!

    @IBOutlet weak var rejectBtn: UIButton!

    var callForAnInterView: (() -> Void)?
    var reject: (() -> Void)?
    
    @IBAction func interviewBtnTap(_ sender: UIButton) {
        callForAnInterView?()
    }
    
    @IBAction func rejectBtnTap(_ sender: UIButton) {
        reject?()
    }
    
    @objc func imageTap() {
        print("image tap")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
