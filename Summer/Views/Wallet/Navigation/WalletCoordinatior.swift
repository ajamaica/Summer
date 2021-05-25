//
//  WalletViewCoordinatior.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation

protocol WalletCoordinatorDelegate: AnyObject { }

final class WalletCoordinator: Coordinator {
    weak var delegate: WalletCoordinatorDelegate?
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = WalletViewModel(solana: applicationComponent.solanaModule.solana)
        let viewController = WalletViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension WalletCoordinator: WalletViewControllerDelegate {
    func goToToken() {
        showToken()
    }

    func goToSettings() {
        showSettings()
    }
}
