//
//  CreateWalletViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import UIKit
import RxSwift

protocol CreateWalletViewControllerDelegate: AnyObject {
    func goToWallet()
}

class CreateWalletViewController: UIViewController {

    let disposeBag = DisposeBag()
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
        self.title = "Seed Phrase"

        seedPhaseCollection.delegate = self
        seedPhaseCollection.dataSource = self
        seedPhaseCollection.register(UINib(nibName: SeedPhaseCollectionViewCellIndentifier, bundle: nil), forCellWithReuseIdentifier: SeedPhaseCollectionViewCellIndentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func doneAction(_ sender: Any) {
        self.viewModel.createWallet().subscribe(onSuccess: {
            self.delegate?.goToWallet()
        }).disposed(by: disposeBag)
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
