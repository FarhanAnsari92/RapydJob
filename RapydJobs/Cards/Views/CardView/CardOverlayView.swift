//
//  CardOverlayView.swift
//  RapydJobs
//
//  Created by Syed Bilal on 04/12/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit
import Koloda

private let overlayRightImageName = "ic_tick_green"
private let overlayLeftImageName = "ic_cross_big"
private let overlayUptImageName = "ic_double-tick"
private let overlayDownImageName = "ic_star_yellow"

class CardOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            case .up? :
                overlayImageView.image = UIImage(named: overlayUptImageName)
            case .down? :
                overlayImageView.image = UIImage(named: overlayDownImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }
    
}
