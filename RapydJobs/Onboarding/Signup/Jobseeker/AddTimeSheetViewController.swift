//
//  AddTimeSheetViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/7/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import QVRWeekView

class AddTimeSheetViewController: UIViewController, WeekViewDelegate {
    
    @IBOutlet weak var weekView: WeekView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add TimeSheet"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        weekView.maximumZoomScale = 3.0
        weekView.minimumZoomScale = 0.75
        weekView.delegate = self
    }
    
    func didLongPressDayView(in weekView: WeekView, atDate date: Date) {
        print(date)
    }
    
    func didTapEvent(in weekView: WeekView, withId eventId: String) {
        print(eventId)
    }
    
    func eventLoadRequest(in weekView: WeekView, between startDate: Date, and endDate: Date) {
        print(startDate)
        print(endDate)
    }
}
