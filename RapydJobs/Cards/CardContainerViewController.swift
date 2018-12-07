//
//  CardContainerViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Koloda

protocol CardContainerViewControllerDelegate: class {
    func didFetchedDropDownData()
}

class CardContainerViewController: UIViewController {
    
    weak var delegate: CardContainerViewControllerDelegate?
    var cardFlow: CardFlow = .dashboard

    @IBOutlet weak var cardView: CardView!
    
    lazy var viewModel: CardViewModel = CardViewModel(withFlow: cardFlow, reload: {
        self.cardView.resetCurrentCardIndex()
        self.cardView.reloadData()
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.countOfVisibleCards = 3
        cardView.delegate = self
        cardView.dataSource = self
        
        viewModel.delegate = self
        
        if AppContainer.shared.user.user?.accountType ?? "" == "organization" {
            viewModel.service.getEmployerDropdownJobs()
        }
    }
    
    func judge(like: Like) {
        if viewModel.data.count > 0 {
            let cardItem = viewModel.data[cardView.currentCardIndex]
            viewModel.swiped(card: cardItem, like: like)
        }
    }
    
    func shortlist() {
        if viewModel.data.count > 0 {
            let cardItem = viewModel.data[cardView.currentCardIndex]
            viewModel.shortlisted(card: cardItem)
        }
    }
}

extension CardContainerViewController: CardViewModelDelegate {
    func didFetchedDropDownData() {
        self.delegate?.didFetchedDropDownData()
    }
}

extension CardContainerViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        if viewModel.numberOfCards() > 0 {
            if AppContainer.shared.user.user?.accountType ?? "" == "jobseeker" {            
                let sb = UIStoryboard(name: "JobDetails", bundle: nil)
                let vc = sb.instantiateInitialViewController() as! JobDetailsViewController
                vc.item = viewModel.data[index]
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let profileDetailsVC = JobSeekerProfileViewController.getInstance()
                print(viewModel.data[index].id)
                profileDetailsVC.jobseekerId = viewModel.data[index].id
                self.navigationController?.pushViewController(profileDetailsVC, animated: true)
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        if viewModel.numberOfCards() == 0 {
            return false
        }
        return true
    }
    
}

extension CardContainerViewController: KolodaViewDataSource {
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("Moved to : ", direction)
        let cardItem = viewModel.data[index]
        switch direction {
        case .right:
            (self.parent as? CardViewController)?.isLastActionDeleted = false
            (self.parent as? CardViewController)?.like(data: cardItem, isLike: true)
        case .left:
            (self.parent as? CardViewController)?.isLastActionDeleted = true
            (self.parent as? CardViewController)?.like(data: cardItem, isLike: false)
            break
        case .up:
            (self.parent as? CardViewController)?.isLastActionDeleted = false
            (self.parent as? CardViewController)?.shortList(data: cardItem)
        case .down:
            (self.parent as? CardViewController)?.isLastActionDeleted = false
            (self.parent as? CardViewController)?.superLike(data: cardItem)
        default:
            break
        }
    }
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return viewModel.numberOfCards() == 0 ? 1 : viewModel.numberOfCards()
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up, .down]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let view = Bundle.main.loadNibNamed("CardViewCell", owner: self, options: nil)?.first as? CardViewCell else {
            return UIView()
        }
        
        if viewModel.numberOfCards() > 0 {
            let cardItem = viewModel.data[index]
            cardItem.shouldHide = index == 0 ? false : true
            view.populateWithCardItem(cardItem)
        } else {
            let cardItem = CardViewItem()
            cardItem.shouldHide = true
            view.populateWithCardItem(cardItem)
        }

        return view
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CardOverlayView", owner: self, options: nil)?[0] as? OverlayView
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
