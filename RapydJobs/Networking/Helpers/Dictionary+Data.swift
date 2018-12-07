//
//  Dictionary+Data.swift
//  RapydJobs
//
//  Created by Maroof Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func toJSONData() throws -> Data  {
        return try JSONEncoder()
            .encode(self)
    }
}

extension Dictionary where Key == String, Value == String? {
    
    func toJSONData() throws -> Data {
        return try JSONEncoder()
            .encode(filter { $0.value != nil })
    }
}

extension Dictionary where Key == String, Value == Dictionary<String, String> {
    func toJSONData() throws -> Data  {
        return try JSONEncoder()
            .encode(self)
    }
}

extension Dictionary where Key == String, Value == Dictionary<String, String?> {
    func toJSONData() throws -> Data  {
        return try JSONEncoder()
            .encode(self)
    }
}

extension Dictionary where Key == String, Value == Array<Dictionary<String, String>> {
    func toJSONData() throws -> Data  {
        return try JSONEncoder()
            .encode(self)
    }
}

extension Dictionary where Key == String, Value == Array<String> {
    func toJSONData() throws -> Data  {
        return try JSONEncoder()
            .encode(self)
    }
}

extension Dictionary where Key == String, Value == Array<Dictionary<String, String?>> {
    func toJSONData() throws -> Data  {
        return try JSONEncoder()
            .encode(self)
    }
}
