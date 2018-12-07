//
//  JobseekerEducationCell.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 24/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit

class JobseekerEducationCell: UITableViewCell {

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
        label.text = "Bachelor Of Science"
        label.textAlignment = .left
        label.textColor = AppConstants.shared.buttonGradientStart
        label.font = UIFont(name: "Poppins-SemiBold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let institutionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Kent University, UK"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let educationDurationLabel: UILabel = {
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
        institutionNameLabel.text?.removeAll()
        educationDurationLabel.text?.removeAll()
    }
    
    private func setupViews() {
        
        self.backgroundColor = .clear
        
        self.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(institutionNameLabel)
        mainStackView.addArrangedSubview(educationDurationLabel)
    }
    
    func populate(with education: SignupEducation) {
        
        titleLabel.text = education.educationTitle
        institutionNameLabel.text = education.institutionName
        educationDurationLabel.text = "\(education.to) - \(education.from)"
    }
    
    func populate(with education: EducationModel) {
        
        titleLabel.text = education.title ?? ""
        institutionNameLabel.text = education.instituteName ?? ""
        
        let to = education.to ?? ""
        let from = education.from ?? ""
        educationDurationLabel.text = "\(to) - \(from)"
    }
}
