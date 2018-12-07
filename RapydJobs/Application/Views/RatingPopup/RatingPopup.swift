//
//  RatingPopup.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/4/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Cosmos

class RatingPopup: UIView, UITextViewDelegate {
    
    @IBOutlet var addReviewTextView: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var parentView: UIView!
    var placeholderLabel : UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.settings.starSize = 30
        self.parentView.layer.cornerRadius = 10
        self.ratingView.layer.cornerRadius = 5
        
    }
    
    var completion: (([String:Any]) -> Void)?
    
    init?(completion handler:(([String:Any]) ->Void)?) {
        
        let window = UIApplication.shared.keyWindow!
        
        super.init(frame: window.bounds)
        self.frame = window.bounds
        
        let nibName = "RatingPopup"
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        view.frame = self.frame
        self.addSubview(view)
        
        self.setupTextView()
        
        self.completion = handler
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            window.addSubview(self)
        })
        
    }
    
    func setupTextView() {
        addReviewTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Add a review"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (addReviewTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        addReviewTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (addReviewTextView.font?.pointSize)! / 2)
        
        placeholderLabel.textColor = UIColor(red: 85 / 255, green: 85 / 255, blue: 85 / 255, alpha: 1.0)
        placeholderLabel.isHidden = !addReviewTextView.text.isEmpty
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        print(ratingView.rating)
        if let review = self.addReviewTextView.text,
            review.count > 0,
            ratingView.rating > 0{
            self.completion?(["rate": ratingView.rating, "review": review])
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.removeFromSuperview()
            })
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

}
