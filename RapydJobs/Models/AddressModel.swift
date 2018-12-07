//
//  AddressModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class AddressModel: Mappable {
    
    var address: String?
    var buildingFloor: String?
    var distance: String?
    var addressId: Int?
    var latitude: String?
    var longitude: String?
    var postalCode: String?
        
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        addressId <- map["id"]
        postalCode <- map["postal_code"]
        buildingFloor <- map["building_floor"]
        distance <- map["distance"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
    
}
