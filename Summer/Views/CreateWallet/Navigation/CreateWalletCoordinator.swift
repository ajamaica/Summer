//
//  CreateWalletCoordinator.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation

protocol CreateWalletCoordinatorDelegate: AnyObject { }

final class CreateWalletCoordinator: Coordinator {
    weak var delegate: CreateWalletCoordinatorDelegate?
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = CreateWalletViewModel(solana: applicationComponent.solanaModule.solana)
        let viewController = CreateWalletViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension CreateWalletCoordinator: CreateWalletViewControllerDelegate {
    func goToWallet() {
        showWallet()
    }
}
