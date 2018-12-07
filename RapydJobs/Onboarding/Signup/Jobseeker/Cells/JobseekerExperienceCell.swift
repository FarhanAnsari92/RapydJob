//
//  JobseekerExperienceCell.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 24/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit

class JobseekerExperienceCell: UITableViewCell {
    
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Business Head"
        label.textAlignment = .left
        label.textColor = AppConstants.shared.buttonGradientStart
        label.font = UIFont(name: "Poppins-SemiBold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let employerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Rapyd Jobs"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let employementDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "Jan 2018 - Sep 2018"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text?.removeAll()
        employerNameLabel.text?.removeAll()
        employementDurationLabel.text?.removeAll()
    }
    
    private func setupViews() {
        
        self.backgroundColor = .clear
        
        self.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(employerNameLabel)
        mainStackView.addArrangedSubview(employementDurationLabel)
    }
    
    func populate(with experience: SignupExperience) {
        
        titleLabel.text = experience.jobTitle
        employerNameLabel.text = experience.employerName
        employementDurationLabel.text = "\(experience.to) - \(experience.from)"
    }
    
    func populate(with experience: ExperienceModel) {
        
        titleLabel.text = experience.title ?? ""
        employerNameLabel.text = experience.companyName ?? ""
        let to = experience.to ?? ""
        let from = experience.from ?? ""
        employementDurationLabel.text = "\(to) - \(from)"
    }
}
