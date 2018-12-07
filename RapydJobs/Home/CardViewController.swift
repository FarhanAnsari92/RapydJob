//
//  CardViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Koloda

class CardViewController: UIViewController {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var viewModel: CardViewModel = CardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.countOfVisibleCards = 3
        cardView.delegate = self
        cardView.dataSource = self
        
        noDataLabel.isHidden = viewModel.shouldShowNoDataLabel()
    }
}

extension CardViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        noDataLabel.isHidden = viewModel.shouldShowNoDataLabel()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        // Open info here
    }
}

extension CardViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return viewModel.numberOfCards()
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let view = Bundle.main.loadNibNamed("CardViewCell", owner: self, options: nil)?.first as? CardViewCell else {
            return UIView()
        }
        
        let cardItem = viewModel.data[index]
        cardItem.shouldHide = index == 0 ? false : true
        view.populateWithCardItem(cardItem)

        return view
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil // make overlay view for swaps
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
        let currentVisibleIndex = koloda.currentCardIndex
        let nextIndex = currentVisibleIndex + 1
        if nextIndex < viewModel.numberOfCards() {
            let cardItem = viewModel.data[nextIndex]
            cardItem.shouldHide = false
            guard let view = koloda.viewForCard(at: nextIndex) as? CardViewCell else {return}
            view.populateWithCardItem(cardItem)
        }
    }
}
