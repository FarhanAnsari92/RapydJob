//
//  RangeField.swift
//  RapydJobs
//
//  Created by Maroof Khan on 02/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import WARangeSlider

class RangeField: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var slider: RangeSlider!
    @IBOutlet weak var rangeMinLabel: UILabel!
    @IBOutlet weak var rangeMinValue: UILabel!
    @IBOutlet weak var rangeMaxLabel: UILabel!
    @IBOutlet weak var rangeMaxValue: UILabel!
    
    var viewModel: RangeViewModel?
    
    convenience init() {
        self.init(frame: .zero)
        embed(view: loadNib()!)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        embed(view: loadNib()!)
        setup()
    }
    
    private func loadNib() -> UIView? {
        return Bundle.main.loadNibNamed("RangeField", owner: self, options: nil)?.first as? UIView
    }
    
    private func setup() {
        titleLabel.font = Constants.Fonts.fieldTitle
        titleLabel.textColor = .lightGray
        
        rangeMinLabel.font = Constants.Fonts.fieldTitle.withSize(8.0)
        rangeMinLabel.textColor = .lightGray
        
        rangeMinValue.font = Constants.Fonts.fieldTitle.withSize(8.0)
        
        rangeMaxLabel.font = Constants.Fonts.fieldTitle.withSize(8.0)
        rangeMaxLabel.textColor = .lightGray
        
        rangeMaxValue.font = Constants.Fonts.fieldTitle.withSize(8.0)
        
        
        slider.addTarget(self, action: #selector(rangeSliderValueChanged),
                              for: .valueChanged)
        
    }
    
    @objc func rangeSliderValueChanged() {
        rangeMinValue.text = "\(slider.lowerValue.rounded())"
        rangeMaxValue.text = "\(slider.upperValue.rounded())"
        
        viewModel?.range.value = (slider.lowerValue.rounded(), slider.upperValue.rounded())
    }
    
    func setup(with viewModel: RangeViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        
        slider.minimumValue = Double(viewModel.minimum.value)
        slider.maximumValue = Double(viewModel.maximum.value)
        
        rangeMinLabel.text = viewModel.minimum.title
        rangeMaxLabel.text = viewModel.maximum.title
        
        rangeMinValue.text = "\(viewModel.minimum.value)"
        rangeMaxValue.text = "\(viewModel.maximum.value)"
    }
    
}
