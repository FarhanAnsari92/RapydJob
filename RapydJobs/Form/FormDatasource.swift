//
//  FormDatasource.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import UIKit

enum FormComponent {
    case action(viewModel: FormActionViewModel)
    case field(viewModel: FormFieldViewModel)
    case options(viewModel: FormOptionsViewModel)
    case pin(viewModel: FormPinCodeViewModel)
    case statement(viewModel: FormStatementViewModel)
    case entry(viewModel: FormEntryViewModel)
    case range(viewModel: RangeViewModel)
    
    var height: CGFloat {
        switch self {
        case .field, .options: return 85.0
        case .action: return 55.0
        case .pin: return 36.0
        case .statement: return 45.0
        case .entry: return 115.0
        case .range: return 85.0
        }
    }
}

class Form {
    
    var components: [FormComponent]
    
    var tableViewHeight: CGFloat {
        return components.reduce(0.0) { (result, component) -> CGFloat in
            return result + component.height
        }
    }
    
    func update(components: [FormComponent]) {
        self.components = components
    }
    
    init(components: [FormComponent]) {
        self.components = components
    }
}
