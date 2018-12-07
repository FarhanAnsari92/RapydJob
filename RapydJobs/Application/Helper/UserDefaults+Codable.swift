//
//  UserDefaults+Codable.swift
//  RapydJobs
//
//  Created by Maroof Khan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    public func set<T: Codable>(object: T, forKey: String) {
        let data = try! JSONEncoder().encode(object)
        set(data, forKey: forKey)
    }
    
    public func get<T: Codable>(forKey: String) -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        
        return try! JSONDecoder().decode(T.self, from: result)
    }
}
