//
//  StartViewController.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import UIKit
import RxSwift

protocol StartViewControllerDelegate: AnyObject {
    func goToStartUpsell()
    func goToWallet()
}
class StartViewController: UIViewController {

    let disposeBag = DisposeBag()
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
        self.viewModel.hasAccount()
            .delay(.seconds(Int(seconds)), scheduler: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.delegate?.goToWallet()
            }, onFailure: { _ in 
                self.delegate?.goToStartUpsell()
            }).disposed(by: disposeBag)
    }

}
