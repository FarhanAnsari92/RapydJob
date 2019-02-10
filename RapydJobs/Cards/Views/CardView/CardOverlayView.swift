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

private let overlayRightImageName = "checked"
private let overlayLeftImageName = "cross"
private let overlayUptImageName = "redo"
private let overlayDownImageName = "star"

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
