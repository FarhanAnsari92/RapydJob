//
//  Initializable.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit


protocol Initializable where Self:UIViewController {
    static var storyboardName:String { get }
}

extension Initializable {
    private static var identifier : String {
        let name = String.init(describing: Self.self)
        return name
    }
    
    static func getInstance() -> Self {
        print(self.storyboardName)
        let storyboard = UIStoryboard(name: self.storyboardName, bundle: nil)
        let instance = storyboard.instantiateViewController(withIdentifier: identifier)
        return instance as! Self
    }
}
