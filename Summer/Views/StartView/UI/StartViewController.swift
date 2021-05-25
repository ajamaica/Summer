//
//  StartViewController.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import UIKit

protocol StartViewControllerDelegate: AnyObject {
    func goToStartUpsell()
    func goToWallet()
}
class StartViewController: UIViewController {

    let viewModel: StartViewModel
    weak var delegate: StartViewControllerDelegate?
    init( viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.viewModel.hasAccount { result in
                switch result {
                case .success():
                    self.delegate?.goToWallet()
                case .failure:
                    self.delegate?.goToStartUpsell()
                }
            }
        }
    }

}
