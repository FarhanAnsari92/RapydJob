//
//  JobseekerLanguageCell.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 24/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit

class JobseekerLanguageCell: UITableViewCell {

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
        label.text = "English"
        label.textAlignment = .left
        label.textColor = AppConstants.shared.buttonGradientStart
        label.font = UIFont(name: "Poppins-SemiBold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Expert"
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
        languageLevelLabel.text?.removeAll()
    }
    
    private func setupViews() {
        
        self.backgroundColor = .clear
        
        self.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(languageLevelLabel)
    }
    
    func populate(with language: SignupLanguage) {
        
        titleLabel.text = language.language
        languageLevelLabel.text = language.level
    }
    
    func populate(with language: LanguageModel) {
        
        titleLabel.text = language.language ?? ""
        languageLevelLabel.text = language.level ?? ""
    }
}
