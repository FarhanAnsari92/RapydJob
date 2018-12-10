//
//  DefaultWeekView.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 4/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DefaultWeekView: JZBaseWeekView {
    
    override func registerViewClasses() {
        super.registerViewClasses()
        
        self.collectionView.register(UINib(nibName: "EventCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.configureCell(event: getCurrentEvent(with: indexPath) as! DefaultEvent)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = getCurrentEvent(with: indexPath) as! DefaultEvent
        //ToastUtil.toastMessageInTheMiddle(message: selectedEvent.title)
    }
}
