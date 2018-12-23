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
    
    var sectors = Helper.getSectors()
    var selectedSectors: [String]?
    var selectedSectorCompletion: (([String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Job Sectors"
        
        if let selectedSectors = self.selectedSectors, selectedSectors.count > 0 {
            for sectorItem in sectors {
                for selectedSectorItem in selectedSectors {
                    let trimmedString = selectedSectorItem.trimmingCharacters(in: .whitespaces)
                    if sectorItem.sectorTitle == trimmedString {
                        sectorItem.isSelected = true
                    }
                }
            }
        }
        print(sectors)
        
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
        
    }
    
    @objc func didTapSaveButton() {
        if let sectrs = self.selectedSectors {
            selectedSectorCompletion?(sectrs)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension RelatedFieldsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RelatedFieldsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateData(self.sectors[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RelatedFieldsCollectionViewCell else {
            return
        }
        
        self.sectors[indexPath.row].isSelected = !self.sectors[indexPath.row].isSelected
        self.collectionView.reloadItems(at: [indexPath])
        
        if self.sectors[indexPath.row].isSelected {
            self.selectedSectors?.append(self.sectors[indexPath.row].sectorTitle)
        } else {
            for (i, item) in (self.selectedSectors?.enumerated())! {
                let trimmedString = item.trimmingCharacters(in: .whitespaces)
                if trimmedString == self.sectors[indexPath.row].sectorTitle {
                    self.selectedSectors?.remove(at: i)
                    break
                }
            }
        }
        print(self.selectedSectors!)
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
