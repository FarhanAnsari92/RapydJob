//
//  SettingModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class SettingModel: NSObject {
    var title: String
    var rows: [SettingRowModel]
    
    init(_ title:String, _ rows:[SettingRowModel]) {
        self.title = title
        self.rows = rows
    }
}

enum SettingRowType {
    case normal
    case edit
    case disclose
    case alert
    case notification
}

class SettingRowModel: NSObject {
    var title: String
    var type: SettingRowType
    
    init(_ title:String, _ type:SettingRowType) {
        self.title = title
        self.type = type
    }
}
