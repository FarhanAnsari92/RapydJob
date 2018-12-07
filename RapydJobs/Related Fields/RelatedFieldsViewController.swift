//
//  RelatedFieldsViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class RelatedFieldsViewController: BaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: RelatedFieldsViewModel = RelatedFieldsViewModel()
    var completion: (([String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Job Sectors"
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveButton))
        addGradient()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "RelatedFieldsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        self.collectionView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.data.removeAll()
    }
    
    @objc func didTapSaveButton() {
        completion?(newRelatedFielfds)
        self.navigationController?.popViewController(animated: true)
    }
}

extension RelatedFieldsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RelatedFieldsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.populateWithCellModel(viewModel.data[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RelatedFieldsCollectionViewCell else {
            return
        }
        let model = viewModel.data[indexPath.row]
        model.isActive = !model.isActive
        cell.populateWithCellModel(model)
        
        if model.isActive {
            newRelatedFielfds.append(model.title)
        } else {
            for (i, item) in newRelatedFielfds.enumerated() {
                if model.title.lowercased() == item.lowercased() {
                    newRelatedFielfds.remove(at: i)
                    break
                }
            }
        }
        
        print(newRelatedFielfds)
        
        var jobSectors = AppContainer.shared.job.jobSectors
        jobSectors[model.title] = model.isActive
        AppContainer.shared.job.save(jobSectors: jobSectors)
    }
}

extension RelatedFieldsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 40, height: collectionView.frame.size.width/3 - 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension RelatedFieldsViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.relatedFields.rawValue
    }
}
