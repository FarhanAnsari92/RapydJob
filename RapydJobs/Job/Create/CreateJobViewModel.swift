//
//  CreateJobViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 03/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol AlertPresenter: class {
    func present(alert: UIAlertController)
    func presentOptions(selected: @escaping (String) -> Void)
}

final class InputViewModel {
    let title: String?
    let keyboard: UIKeyboardType
    let placeholder: String?
    let value: MutableProperty<String>
    let error: MutableProperty<String>?
    
    init(title: String?, placeholder: String? = nil, keyboard: UIKeyboardType = .default, value: MutableProperty<String>, error: MutableProperty<String>? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.keyboard = keyboard
        self.value = value
        self.error = error
    }
}

protocol OptionsPresenter: class {
    func present<Option>(options: [Option], selected: (Int) -> Void)
}

final class SelectableInputViewModel {
    let options: [String]
    let title: String
    let value: MutableProperty<String>
    let openRelatedFields: Bool
    weak var presenter: AlertPresenter?
    
    init(title: String, options: [String], value: MutableProperty<String>, openRelatedFields: Bool, presenter: AlertPresenter) {
        self.title = title
        self.options = options
        self.value = value
        self.presenter = presenter
        self.openRelatedFields = openRelatedFields
    }
}

final class SubmitViewModel {
    let title: String
    let submission: () -> Void
    init(title: String, submission: @escaping () -> Void) {
        self.title = title
        self.submission = submission
    }
}

enum Field {
    case input(InputViewModel)
    case indefiniteInput(InputViewModel)
    case range(RangeViewModel)
    case selectable(SelectableInputViewModel)
    case submit(SubmitViewModel)
}

final class CreateJobViewModel {
    
    class Delegate: NSObject, UITableViewDelegate {
        let components: [Field]
        init(components: [Field]) {
            self.components = components
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch components[indexPath.row] {
            case .input, .indefiniteInput, .selectable, .range: return 85.0
            case .submit: return 55.0
            }
        }
    }
    
    class Datasource: NSObject, UITableViewDataSource {
        
        let components: [Field]
        init(components: [Field]) {
            self.components = components
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return components.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let content: UIView
            
            switch components[indexPath.row] {
            case .input(let vm):
                let view = BaseFieldView()
                view.viewModel = vm
                content = view
                
            case .indefiniteInput(let vm):
                let view = BaseFieldView()
                view.viewModel = vm
                content = view
                
            case .range(let vm):
                let view = RangeField()
                view.setup(with: vm)
                content = view
                
            case .selectable(let vm):
                let view = BaseFieldSelectableView()
                view.vm = vm
                
                content = view
                
            case .submit(let vm):
                let view = BaseButtonView()
                view.vm = vm
                content = view
            }
            
            let cell = UITableViewCell()
            cell.contentView.embed(view: content, insets: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0))
            return cell
        }
    }
    
    let presenter: AlertPresenter
    var datasource: Datasource!
    var delegate: Delegate!
    
    lazy var service: JobService = {
       let service = JobService(delegate: self)
        service.delegate = self
        return service
    }()
    
    let title = MutableProperty<String>("")
    let sector = MutableProperty<String>("Job Sector")
    let description = MutableProperty<String>("")
    let salaryRange = MutableProperty<(Double, Double)>((0, 0))
    let shift = MutableProperty<String>("Morning")
    let type = MutableProperty<String>("Part Time")
    let length = MutableProperty<String>("1 week")
    
    lazy var titleInput = InputViewModel(title: "Job Title", value: title)
    lazy var sectorVM = SelectableInputViewModel(title: "Job Sector", options: [], value: sector, openRelatedFields: true, presenter: presenter)
    lazy var descriptionInput = InputViewModel(title: "Job Description", value: description)
    
    lazy var salaryRangeVM = RangeViewModel(title: "Salary Range",
                                          minimum: (value: 1, title: "Min. Salary", formatter: { return "\($0)$" }),
                                          maximum: (value: 99, title: "Max. Salary", formatter: { return "\($0)$" }),
                                          range: salaryRange)
    
    lazy var shiftVM = SelectableInputViewModel(title: "Shift Timing", options: ["Morning", "Afternoon", "Evening"], value: shift, openRelatedFields: false, presenter: presenter)
    lazy var typeVM = SelectableInputViewModel(title: "Job Type", options: ["Part Time", "Full Time"], value: type, openRelatedFields: false, presenter: presenter)
    lazy var lengthVM = SelectableInputViewModel(title: "Length of Contract", options: ["1 week", "2 weeks", "3 weeks", "1 month"   , "2 months", "3 months"], value: length, openRelatedFields: false, presenter: presenter)
    lazy var submission = SubmitViewModel(title: "Post a job", submission: submit)
    
    lazy var components: [Field] = [
        .input(titleInput),
        .selectable(sectorVM),
        .indefiniteInput(descriptionInput),
        .range(salaryRangeVM),
        .selectable(shiftVM),
        .selectable(typeVM),
        .selectable(lengthVM),
        .submit(submission)
    ]
    
    init(presenter: OptionsPresenter & AlertPresenter) {
        self.presenter = presenter
        self.datasource = Datasource(components: components)
        self.delegate = Delegate(components: components)
    }
    
    func submit() {
        
        let job = Job(title: title.value, sector: sector.value, description: description.value, salary: salaryRange.value, shift: shift.value, type: type.value, length: length.value)
        service.create(job: job)
    }
}

extension CreateJobViewModel: JobServiceDelegate {
    func failuer(error: NetworkError) {
        let alert = UIAlertController(title: "Job creation failed.", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presenter.present(alert: alert)
    }
    
    func created() {
        let alert = UIAlertController(title: "Job created", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in AppRouter.shared.proceed() }))
        presenter.present(alert: alert)
    }
}

struct Job {
    let title: String
    let sector: String
    let description: String
    let salary: (minimum: Double, maximum: Double)
    let shift: String
    let type: String
    let length: String
}
