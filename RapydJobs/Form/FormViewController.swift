//
//  FormViewController.swift
//  Rapyd
//
//  Created by Maroof Khan on 23/06/2018.
//

import UIKit
import MBProgressHUD
import SwiftVideoBackground

class FormViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    @IBOutlet private weak var linkedinButton: UIButton!
    @IBOutlet private weak var statementLabel: UILabel!
    @IBOutlet private weak var statementButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    
    @IBOutlet private var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    //var progressView = SignupProgressView()
    
    @IBOutlet weak var tableViewBottomToStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomToSuperConstraint: NSLayoutConstraint!
    var viewModel: FormViewModel! {
        didSet { viewModel.delegate = self }
    }
    
    var components: [FormComponent] {
        return viewModel.form?.components ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Video
        let whiteView = UIView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        whiteView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        whiteView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(whiteView)
        self.view.sendSubview(toBack: whiteView)
        VideoBackground.shared.darkness = 0
        VideoBackground.shared.isMuted = true
        VideoBackground.shared.willLoopVideo = true

        // Progress View
        //progressView = SignupProgressView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.size.width, height: 5))
//        progressView.isHidden = false
//        progressView.progress = CGFloat(self.viewModel.progress)
//        self.view.addSubview(progressView)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 115.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setup(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shapeLinkedinButton(button: linkedinButton)
        setupStatementSection()
        
        try? VideoBackground.shared.play(view: view, videoName: "Background", videoType: "mp4")

        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setup(viewModel: FormViewModel) {
        tableView.dataSource = self
        tableView.delegate = self.components.contains(where: {
            if case let .entry(vm) = $0 { return true }
            else { return false }
        }) ? nil : self
        
        tableViewHeight.constant = CGFloat(viewModel.tableViewHeight)
        
        if (viewModel.shouldHideButtomStack) {
            self.tableViewBottomToStackConstraint.priority = .defaultLow
            self.tableViewBottomToSuperConstraint.priority = .defaultHigh
            self.bottomStackView.isHidden = true
        } else {
            self.tableViewBottomToStackConstraint.priority = .defaultHigh
            self.tableViewBottomToSuperConstraint.priority = .defaultLow
            self.bottomStackView.isHidden = false
        }

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        titleLabel.kerning = 2
        
        if let statment = viewModel.statement, let action = viewModel.action {
            statementLabel.text = statment
            statementButton.setTitle(action.title, for: .normal)
        } else {
            statementLabel.isHidden = true
            statementButton.isHidden = true
        }
        
        if let secondaryCTA = viewModel.secondaryCTA?.uppercased() {
            linkedinButton.setTitle(secondaryCTA, for: .normal)
        } else {
            linkedinButton.isHidden = true
        }
        
        if let _ = viewModel.add {
            addButton.isHidden = false
            addButton.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        } else {
            addButton.isHidden = true
        }
    }
    
    @objc private func add(_ sender: UIButton) {
        viewModel.add?()
    }
    
    private func shapeLinkedinButton(button: UIButton) {
        button.layer.cornerRadius = button.bounds.midY
        button.backgroundColor = Constants.Colors.linkedIn
        button.setImage(UIImage(named: "ic_linkedin")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    }
    
    private func setupStatementSection() {
        statementButton.addTarget(self, action: #selector(statementCTA(_:)), for: .touchUpInside)
    }
    
    @objc private func statementCTA(_ sender: UIButton) {
        viewModel.action?.action()
    }
}

extension FormViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formField: (FormFieldViewModel) -> FormFieldTableViewCell = { viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "form-field") as! FormFieldTableViewCell
            cell.setup(with: viewModel)
            
            return cell
        }
        
        let formAction: (FormActionViewModel) -> FormActionTableViewCell = { viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "form-action") as! FormActionTableViewCell
            cell.setup(with: viewModel)
            
            return cell
        }
        
        let formOptions: (FormOptionsViewModel) -> FormOptionsTableViewCell = { viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "form-options") as! FormOptionsTableViewCell
            cell.setup(with: viewModel)
            
            return cell
        }

        let formPinCode: (FormPinCodeViewModel) -> FormPinCodeTableViewCell = { viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "form-pin-code") as! FormPinCodeTableViewCell
            cell.setup(with: viewModel)

            return cell
        }
        
        let formStatement: (FormStatementViewModel) -> FormStatementTableViewCell = {
            viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "form-statement") as! FormStatementTableViewCell
            cell.setup(with: viewModel)
            
            return cell
        }
        
        let formEntry: (FormEntryViewModel) -> FormEntryTableViewCell = {
            viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "form-entry") as! FormEntryTableViewCell
            cell.setup(with: viewModel) {
                viewModel.expanded = !viewModel.expanded
                UIView.animate(withDuration: 0.3, animations: {
                    cell.expandButton.transform = CGAffineTransform(rotationAngle: viewModel.expanded ? (-2 * CGFloat.pi) : CGFloat.pi)
                })
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            return cell
        }
        
        let component = components[indexPath.row]
        switch component {
        case .field(let viewModel):
            return formField(viewModel)
        case .action(let viewModel):
            return formAction(viewModel)
        case .options(let viewModel):
            return formOptions(viewModel)
        case .pin(let viewModel):
            return formPinCode(viewModel)
        case .statement(let viewModel):
            return formStatement(viewModel)
        case .entry(let viewModel):
            return formEntry(viewModel)
        case .range(let viewModel):
            let cell = UITableViewCell()
            let range = RangeField()
            range.setup(with: viewModel)
            cell.contentView.embed(view: range)
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let component = components[indexPath.row]
        return component.height
    }
    
    // Editing of rows is enabled
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            viewModel.form.components.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .none)
//        }
//    }
}

extension FormViewController: Initializable {
    static var storyboardName: String { return "Form" }
}

extension FormViewController: FormViewModelDelegate {
    
    func presentReleatedFields(selected: @escaping (String) -> Void) {
        let controller: RelatedFieldsViewController = .getInstance()
        let viewModel = RelatedFieldsViewModel(selected: selected)
       // controller.viewModel = viewModel
        
        present(controller, animated: true, completion: nil)
    }
    
    func present(controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
    
    func showProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func redo() {
        setup(viewModel: viewModel)
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
