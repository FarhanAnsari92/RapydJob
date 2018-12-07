//
//  DaySelector.swift
//  RapydJobs
//
//  Created by Maroof Khan on 26/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

enum Month: String {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}



class DaySelector {
    
    class Datasource: NSObject, UICollectionViewDataSource {
        
        let dates: [Date]
        let weekday: DateFormatter = {
            $0.dateFormat = "E"
            return $0
        }(DateFormatter())
        
        let day: DateFormatter = {
            $0.dateFormat = "d"
            return $0
        }(DateFormatter())

        init(for month: Month, year: Int) {
            let calender: Calendar = .current
            let components: DateComponents = .init(year: year, month: month.hashValue)
            let date = calender.date(from: components)!
            let days = calender.range(of: .day, in: .month, for: date)!
            self.dates = (days.lowerBound..<days.upperBound).map {
                let components: DateComponents = .init(year: year, month: month.hashValue, day: $0)
                return calender.date(from: components)!
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dates.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day-selector", for: indexPath) as! DaySelectorCollectionViewCell
            
            let date = dates[indexPath.row]
                
            let viewModel = DaySelectorCellViewModel(weekday: weekday.string(from: date), day: day.string(from: date))
            cell.setup(with: viewModel)
                
            return cell
        }
    }
    
    let datasource: Datasource
    let month: Month
    let year: Int
    init(month: Month, year: Int) {
        self.month = month
        self.year = year
        self.datasource = .init(for: month, year: year)
    }
}
