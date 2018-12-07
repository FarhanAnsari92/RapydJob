//
//  CardView.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Koloda

class CardView: KolodaView {

    override func frameForCard(at index: Int) -> CGRect {
        let defaultBackgroundCardsTopMargin = -self.frame.height / 4
        let defaultBackgroundCardsScalePercent: CGFloat = CGFloat(0.88 - (Double(index) * 0.015))

        let bottomOffset: CGFloat = 0
        let topOffset = defaultBackgroundCardsTopMargin * CGFloat(self.countOfVisibleCards - 1)
        let scalePercent = defaultBackgroundCardsScalePercent
        let width = self.frame.width * pow(scalePercent, CGFloat(index))
        let xOffset = (self.frame.width - width) / 2
        let height = (self.frame.height - bottomOffset - topOffset) * pow(scalePercent, CGFloat(index)) + defaultBackgroundCardsTopMargin * 1.5
        let multiplier: CGFloat = index > 0 ? 1.0 : 0.0
        let prevCardFrame = index > 0 ? frameForCard(at: max(index - 1, 0)) : .zero
        let yOffset = (prevCardFrame.height - height + prevCardFrame.origin.y + defaultBackgroundCardsTopMargin) * multiplier
        let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        return frame
    }
}
