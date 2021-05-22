//
//  WalletViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import UIKit

protocol WalletViewControllerDelegate: AnyObject {
    
}

class WalletViewController: UIViewController {

    let viewModel: WalletViewModel
    weak var delegate: WalletViewControllerDelegate?
    init( viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
