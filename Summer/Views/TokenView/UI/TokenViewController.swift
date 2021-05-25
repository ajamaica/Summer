//
//  TokenViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import UIKit
protocol TokenViewControllerDelegate: AnyObject { }

class TokenViewController: UIViewController {

    let viewModel: TokenViewModel
    weak var delegate: TokenViewControllerDelegate?
    init( viewModel: TokenViewModel) {
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
}
