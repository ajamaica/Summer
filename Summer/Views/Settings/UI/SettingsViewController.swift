//
//  SettingsViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func logout()
}

class SettingsViewController: UIViewController {

    let viewModel: SettingsViewModel
    weak var delegate: SettingsViewControllerDelegate?
    init( viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func deleteWallet(_ sender: Any) {
        self.viewModel.logout { result in
            switch result {
            case .success():
                self.delegate?.logout()
            case .failure(_):
                break
            }
        }
    }
}
