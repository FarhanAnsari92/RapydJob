//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class DeleteJobOfferRequest: EndpointProvider {
    typealias Response = DeleteJobOfferResponse
    
    
    private let jobOfferID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-joboffer", jobOfferID], body: nil)
        
    }
    
    init(jobOfferID: String) {
        self.jobOfferID = jobOfferID
    }
    
}

struct DeleteJobOfferResponse: DTO {
    
}
