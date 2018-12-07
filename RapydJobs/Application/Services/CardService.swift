//
//  CardService.swift
//  RapydJobs
//
//  Created by Maroof Khan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CardServiceDelegate: class {
    func employerDropdownJobs(jobs: [EmployerJobsDropdownResponse])
    func userAdjudged()
    func userSuperAdjudged()
    func userSuperSeekerAdjudge()
    func jobAdjudged()
    func userShortlisted()
    func jobShortlisted()
    func success(cards: [JobseekerResponseDTO])
    func success(cards: [JobResponseDTO])
    func failed(error: Error)
}

final class CardService {
    
    var flow: CardFlow
    private weak var delegate: CardServiceDelegate?
    private let network: Network
    
    init(flow: CardFlow, delegate: CardServiceDelegate, network: Network = .shared) {
        self.network = network
        self.delegate = delegate
        self.flow = flow
    }
    
    func getCardData() {
    
        let accountType = AppContainer.shared.user.user?.accountType ?? ""
        //let accountType = AppContainer.shared.user.accountType
        let job = AppContainer.shared.job.jobID
        
        switch flow {
        case .dashboard:
            if accountType == "organization" {
                self.filteredJobseekers(for: job)
            } else {
                self.filteredJobs()
            }
        case .shortlisted:
            if accountType == "organization" {
                self.shortlistedJobseekers(for: job)
            } else {
                self.shortlistedJobs()
            }
        }
    }
    
    private func shortlistedJobs() {
        let request = ShorlistedJobsRequest()
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.success(cards: dto)
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    private func filteredJobs() {
        let request = FilteredJobsRequest()
        network.request(request) { [weak delegate] result in
            print("🌎 Filtered Jobs Response : ", result)
            switch result {
            case let .success(dto):
                delegate?.success(cards: dto)
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }

    private func shortlistedJobseekers(for job: Int) {
        let request = ShorlistedJobseekersRequest(job: job)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.success(cards: dto)
            case let .failure(error):
                delegate?.failed(error: error)
            }
        } 
    }
    
    private func filteredJobseekers(for job: Int) {
        let request = FilteredUsersRequest(job: job)
        network.request(request) { [weak delegate] result in
            print("🌎 Filter Users : ", result)
            switch result {
            case let .success(dto):
                delegate?.success(cards: dto)
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func getEmployerDropdownJobs() {
        let request = EmployerJobsDropdownRequest()
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.employerDropdownJobs(jobs: dto)
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func judge(user: String, job: String, like: Like) {
        let request = AddUserRequest(like: like, user: user, job: job)
        network.request(request) { [weak delegate] result in
            switch result {
            case .success:
                delegate?.userAdjudged()
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func judgeSuperlike(job: String, userId: String) {
        let request = SwipeSuperLikeEmployerRequest(userID: job, jobID: userId)
        network.request(request) { [weak delegate] result in
            switch result {
            case .success:
                delegate?.userSuperAdjudged()
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func judgeSuperlike(job: String) {
        
        let request = SwipeSuperLikeJobSeekerRequest(jobID: job)
        network.request(request) { [weak delegate] result in
            switch result {
            case .success:
                delegate?.userSuperSeekerAdjudge()
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func judge(job: String, like: Like) {
        let request = AddJobRequest(like: like, job: job)
        network.request(request) { [weak delegate] result in
            switch result {
            case .success:
                delegate?.jobAdjudged()
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func shortlist(user: String, job: String) {
        let request = ShorlistUserRequest(job: job, userID: user)
        network.request(request) { [weak delegate] result in
            print("🌎 Shortlist Users : ", result)
            switch result {
            case .success:
                delegate?.userShortlisted()
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }

    func shortlist(job: String) {
        let request = ShorlistJobRequest(job: job)
        network.request(request) { [weak delegate] result in
            print("🌎 Shortlist Jobs : ", result)
            switch result {
            case .success:
                delegate?.jobShortlisted()
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
}

