//
//  StartViewController.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import UIKit

protocol StartViewControllerDelegate: AnyObject { }
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

}
