//
//  SegmentControl.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Segmentio

class SegmentControl: Segmentio {
    
    var content = [SegmentioItem]() {
        didSet {
            commonInit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(1)
            context.move(to: CGPoint(x: 0, y: 0))
            context.addLine(to: CGPoint(x: bounds.width, y: 0))
            context.move(to: CGPoint(x: 0, y: bounds.height))
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            context.strokePath()
        }
    }
    
    private func commonInit() {

        self.selectedSegmentioIndex = 0
        
        let indicatorOptions = SegmentioIndicatorOptions(type: .bottom,
                                                         ratio: 1,
                                                         height: 3,
                                                         color: Constants.Colors.primaryBlueColor)
        
        let horizontalSepOptions = SegmentioHorizontalSeparatorOptions(type: .none,
                                                                       height: 0,
                                                                       color: .clear)
        
        let verticalSepOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: .clear)
        
        let states = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.boldSystemFont(ofSize: 14),
                titleTextColor: .gray
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.boldSystemFont(ofSize: 14),
                titleTextColor: Constants.Colors.primaryBlueColor
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.boldSystemFont(ofSize: 14),
                titleTextColor: .gray
            )
        )
        
        let options = SegmentioOptions(backgroundColor: .white,
                                       segmentPosition: .dynamic,
                                       scrollEnabled: true,
                                       indicatorOptions: indicatorOptions,
                                       horizontalSeparatorOptions: horizontalSepOptions,
                                       verticalSeparatorOptions: verticalSepOptions,
                                       imageContentMode: .scaleAspectFill,
                                       labelTextAlignment: .center,
                                       labelTextNumberOfLines: 1,
                                       segmentStates: states,
                                       animationDuration: 0.1)
        
        self.setup(content: self.content, style: .onlyLabel, options: options)
    }
}
