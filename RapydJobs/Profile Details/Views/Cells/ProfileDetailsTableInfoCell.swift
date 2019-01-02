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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        organisationLabel = ProfileInfoLabel(frame: CGRect(x: 40, y: 0, width: self.rootView.bounds.size.width - 80, height: 20))
        durationLabel = ProfileInfoLabel(frame: CGRect(x: 40, y: 0, width: self.rootView.bounds.size.width - 80, height: 20))
    }
    
    func populateWithBasicInfo(_ basicInfo: ProfileBasicInfoModel) {
        self.toggleButton.isHidden = true
        self.titleLabel.textColor = grayLabelColor
        self.titleLabel.text = basicInfo.text
        self.iconView?.image = basicInfo.image
    }
    
    func populateWithExperienceModel(_ experience: ProfileExperienceModel) {
        self.toggleButton.isHidden = false
        self.titleLabel.textColor = experienceLabelColor
        self.titleLabel.text = experience.jobTitle
        self.organisationLabel.text = experience.organisationName
        self.durationLabel.text = experience.durationString
        self.iconView?.image = UIImage(named: "ic_jobs")
    }
    
    func experience(_ experience: ExperienceModel) {
        self.toggleButton.isHidden = false
        self.titleLabel.textColor = experienceLabelColor
        self.titleLabel.text = experience.title ?? ""
        self.organisationLabel.text = experience.companyName ?? ""
        let duration = (experience.from ?? "") + " - " + (experience.to ?? "")
        self.durationLabel.text = duration
        self.iconView?.image = UIImage(named: "ic_jobs")
    }
    
    @IBAction func didTapToggleButton(_ sender: Any) {
        
        let button = sender as! UIButton
        if button.isSelected {
            detailsStackView.removeArrangedSubview(organisationLabel)
            detailsStackView.removeArrangedSubview(durationLabel)
            button.isSelected = false
            detailsStackView.isHidden = true
        }
        else {
            detailsStackView.isHidden = false
            detailsStackView.addArrangedSubview(organisationLabel)
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
