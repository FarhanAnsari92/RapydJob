//
//  ProfileDetailsTableInfoCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

protocol ProfileDetailsTableInfoCellDelegate: class {
    func infoCellLayoutChanged(_ infoCell: ProfileDetailsTableInfoCell)
}

class ProfileDetailsTableInfoCell: ShdaowBaseTableViewCell {

    let experienceLabelColor = UIColor(red: 97/255.0, green: 191/255.0, blue: 214/255.0, alpha: 1.0)
    let grayLabelColor = UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0)

    weak var delegate:ProfileDetailsTableInfoCellDelegate?
    @IBOutlet weak var detailsStackView: UIStackView!
    var downloadCompletion: (() -> Void)?

    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!

    var organisationLabel = ProfileInfoLabel()
    var durationLabel = ProfileInfoLabel()
    var gradeLabel = ProfileInfoLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        organisationLabel = ProfileInfoLabel(frame: CGRect(x: 40, y: 0, width: self.rootView.bounds.size.width - 80, height: 20))
        durationLabel = ProfileInfoLabel(frame: CGRect(x: 40, y: 0, width: self.rootView.bounds.size.width - 80, height: 20))
        gradeLabel = ProfileInfoLabel(frame: CGRect(x: 40, y: 0, width: self.rootView.bounds.size.width - 80, height: 20))
        gradeLabel.isHidden = true
    }
    
    @IBAction func didTapToggleButton(_ sender: Any) {
        
        let button = sender as! UIButton
        if button.isSelected {
            detailsStackView.removeArrangedSubview(organisationLabel)
            detailsStackView.removeArrangedSubview(gradeLabel)
            detailsStackView.removeArrangedSubview(durationLabel)
            button.isSelected = false
            detailsStackView.isHidden = true
        }
        else {
            detailsStackView.isHidden = false
            detailsStackView.addArrangedSubview(organisationLabel)
            detailsStackView.addArrangedSubview(gradeLabel)
            detailsStackView.addArrangedSubview(durationLabel)
            button.isSelected = true
        }
        
        self.delegate?.infoCellLayoutChanged(self)
    }
    
    @IBAction func download(_ sender: UIButton) {
        self.downloadCompletion?()
    }
}

class ProfileInfoLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.font = UIFont.systemFont(ofSize: 12)
        self.textColor = UIColor.lightGray
    }
}
