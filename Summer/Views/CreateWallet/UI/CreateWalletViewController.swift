//
//  CreateWalletViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import UIKit

protocol CreateWalletViewControllerDelegate: AnyObject {
    
}


class CreateWalletViewController: UIViewController {

    @IBOutlet weak var seedPhaseCollection: UICollectionView!
    let viewModel: CreateWalletViewModel
    weak var delegate: CreateWalletViewControllerDelegate?
    init( viewModel: CreateWalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seedPhaseCollection.delegate = self
        seedPhaseCollection.dataSource = self
        seedPhaseCollection.register(UINib(nibName: SeedPhaseCollectionViewCellIndentifier, bundle: nil), forCellWithReuseIdentifier: SeedPhaseCollectionViewCellIndentifier)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.viewModel.createWallet()
    }
}

let SeedPhaseCollectionViewCellIndentifier = "SeedPhaseCollectionViewCell"
extension CreateWalletViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getSeedPhrase().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeedPhaseCollectionViewCellIndentifier, for: indexPath as IndexPath) as! SeedPhaseCollectionViewCell
        cell.word.text = self.viewModel.getSeedPhrase()[indexPath.row]
        return cell
    }
}
