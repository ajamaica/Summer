//
//  UpsellViewViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/19.
//

import UIKit

protocol UpsellViewControllerDelegate: AnyObject {
    func goToCreateWallet()
    func goToRecoverWallet()
}

class UpsellViewController: UIViewController {

    let viewModel: UpsellViewModel
    weak var delegate: UpsellViewControllerDelegate?
    init( viewModel: UpsellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func recoverAccount(_ sender: Any) {
        delegate?.goToRecoverWallet()
    }

    @IBAction func createNewWallet(_ sender: Any) {
        delegate?.goToCreateWallet()
    }
}
