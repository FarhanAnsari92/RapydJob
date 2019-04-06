//
//  CardViewModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol CardViewModelDelegate: class {
    func didFetchedDropDownData()
    func errorMessage(err: NetworkError)
}

class CardViewModel: NSObject {
    
    weak var delegate: CardViewModelDelegate?
    
    lazy var service = CardService(flow: self.flow, delegate: self)

    var data = [CardViewItem]()
    var allCards: [JobseekerResponseDTO]?
    var dropDownData = [JobsDropDownItem]();
    
    var reload: () -> Void
//    var failed: (Error) -> Void
    
    var flow: CardFlow
    let accountType = AppContainer.shared.user.user?.accountType ?? ""
    
    init(withFlow flow:CardFlow, reload: @escaping () -> Void) {
        self.data = []
        self.reload = reload
//        self.failed = failed
        self.flow = flow
    }
    
    func swiped(card: CardViewItem, like: Like) {
        guard let id = card.id else {
            return
        }
        AppContainer.shared.user.user?.accountType ?? ""  == "organization"
            ? service.judge(user: "\(id)", job: "\(AppContainer.shared.job.jobID)", like: like)
            : service.judge(job: "\(AppContainer.shared.job.jobID)", like: like)
    }
    
    func shortlisted(card: CardViewItem) {
        guard let id = card.id else {
            return
        }
        let jobID = "\(AppContainer.shared.job.jobID)"
        AppContainer.shared.user.user?.accountType ?? ""  == "organization"
            ? service.shortlist(user: "\(id)", job: jobID)
            : service.shortlist(job: jobID)
    }
    
    func numberOfCards() -> Int {
        return data.count
    }
    
    func superLike(card: CardViewItem) {
        let jobID = "\(AppContainer.shared.job.jobID)"
        AppContainer.shared.user.user?.accountType ?? ""  == "organization"        
            ? service.judgeSuperlike(job: jobID, userId: card.userId)
            : service.judgeSuperlike(job: jobID)
        
        
        
    }
}

extension CardViewModel: CardServiceDelegate {
    
    func employerDropdownJobs(jobs: [EmployerJobsDropdownResponse]) {
        self.dropDownData = jobs.map(JobsDropDownItem.init)
        self.delegate?.didFetchedDropDownData()
    }

    func success(cards: [JobResponseDTO]) {
        self.data = cards.map(CardViewItem.init)
        reload()
    }

    func success(cards: [JobseekerResponseDTO]) {
        self.allCards = cards
        self.data = cards.map(CardViewItem.init)
        reload()
    }
    
    func userShortlisted() { }
    
    func jobShortlisted() { }

    func userAdjudged() {
        
    }
    
    func jobAdjudged() { }
    
    func failed(error: NetworkError) {
//        print(error)
        print(error.localizedDescription)
        self.delegate?.errorMessage(err: error)
//        failed(error)
    }
    
    func userSuperSeekerAdjudge() { }
    
    func userSuperAdjudged() { }
}
