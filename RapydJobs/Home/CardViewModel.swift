//
//  CardViewModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class CardViewModel: NSObject {
    
    var data = [CardViewItem]()
    
    override init() {
        let dummyData = CardViewItem("John Smith", "Business Consultant @ Davidson Co.", "face.jpg", 4, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sagittis, augue ut volutpat imperdiet, nisl ex semper neque, eget dictum est eros non eros.", "Business Consultant @ Davidson Co.", "Master Business Administration Marketing", "London, United Kingdom")
        for _ in 0...10 {
            data.append(dummyData)
        }
    }
    
    func numberOfCards() -> Int {
        return data.count
    }
    
    func shouldShowNoDataLabel() -> Bool {
        return data.count <= 0
    }
}
