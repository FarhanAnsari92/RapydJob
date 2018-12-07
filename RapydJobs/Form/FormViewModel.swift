//
//  FormViewModel.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import Foundation
import UIKit

protocol FormViewModelDelegate: class {
    func showProgress()
    func hideProgress()
    func present(controller: UIViewController)
    func presentReleatedFields(selected: @escaping (String) -> Void)
    func dismiss()
    func redo()
}

protocol FormViewModel {
    var title: String { get }
    var subtitle: String { get }
    var progress: Float { get }
    var form: Form! { get }
    var tableViewHeight: Float { get }
    var shouldHideButtomStack: Bool { get }
    var statement: String? { get }
    var secondaryCTA: String? { get }
    var action: (title: String, action: () -> Void)? { get }
    var delegate: FormViewModelDelegate? { get set }
    var add: (() -> Void)? { get }
}

extension FormViewModel {
    var secondaryCTA: String? { return nil }
    var statement: String? { return nil }
    var action: (title: String, action: () -> Void)? { return nil }
    var add: (() -> Void)? { return nil }
}
