//
//  PlannerVC.swift
//  RapydJobs
//
//  Created by MuhammadKhan on 8/27/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import QVRWeekView

class PlannerVC: UIViewController, WeekViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let weekView: WeekView = {
        let wv = WeekView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        PlannerAPIService.shared.getJobseekerSchedule { (error) in
            //
        }
    }

    private func setupViews() {
        
        navigationItem.title = "Planner"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let topFrameHeight = UIApplication.shared.statusBarFrame.height + 44
        
        view.addSubview(weekView)
        weekView.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        weekView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        weekView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        weekView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
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
