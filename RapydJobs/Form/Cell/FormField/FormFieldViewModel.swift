//
//  FormFieldViewModel.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import UIKit
import ReactiveSwift

struct FormFieldViewModel {
    let title: String
    let secure: Bool
    let keyboard: UIKeyboardType
    let value: MutableProperty<String>
    let validator: (String) -> Bool
}
