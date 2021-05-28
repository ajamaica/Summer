//
//  RestoreWalletCoordinator.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

protocol RestoreWalletCoordinatorDelegate: AnyObject { }

class RestoreWalletCoordinator: Coordinator {
    weak var delegate: RestoreWalletCoordinatorDelegate?
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = RestoreWalletViewModel(solana: applicationComponent.solanaModule.solana)
        let viewController = RestoreWalletViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
extension RestoreWalletCoordinator: RestoreWalletViewControllerDelegate {
    func goToWallet() {
        showWallet()
    }
}
