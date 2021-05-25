//
//  StartViewCoordinator.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import Foundation

protocol StartViewCoordinatorDelegate: AnyObject { }

final class StartViewCoordinator: Coordinator {
    weak var delegate: StartViewControllerDelegate?
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = StartViewModel(solana: applicationComponent.solanaModule.solana)
        let viewController = StartViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension StartViewCoordinator: StartViewControllerDelegate {
    func goToWallet() {
        showWallet()
    }

    func goToStartUpsell() {
        showUpsell()
    }
}
