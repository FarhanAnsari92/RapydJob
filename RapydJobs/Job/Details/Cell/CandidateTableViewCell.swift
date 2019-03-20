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
    @IBOutlet weak var interviewBtnParent: UIView!

    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var rejectBtnParent: UIView!

    var callForAnInterView: (() -> Void)?
    var reject: (() -> Void)?
    
    @objc func interviewBtnTap(_ sender: UIButton) {
        callForAnInterView?()
    }
    
    @objc func rejectBtnTap(_ sender: UIButton) {
        reject?()
    }
    
    @objc func imageTap() {
        print("image tap")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let interviewGesture = UITapGestureRecognizer(target: self, action: #selector(self.interviewBtnTap(_:)))
        self.interviewBtnParent.isUserInteractionEnabled = true
        self.interviewBtnParent.addGestureRecognizer(interviewGesture)
        
        let rejectGesture = UITapGestureRecognizer(target: self, action: #selector(self.rejectBtnTap(_:)))
        self.rejectBtnParent.isUserInteractionEnabled = true
        self.rejectBtnParent.addGestureRecognizer(rejectGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
