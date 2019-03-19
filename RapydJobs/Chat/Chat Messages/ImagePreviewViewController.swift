//
//  ImagePreviewViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 3/19/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    var url: String! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.setChatImageWithName(url)
    }
    
    @IBAction func dismissController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
