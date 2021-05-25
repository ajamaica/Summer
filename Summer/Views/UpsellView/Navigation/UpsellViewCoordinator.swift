//
//  UpsellViewCoordinator.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/21.
//

import Foundation

protocol UpsellViewCoordinatorDelegate: AnyObject { }

final class UpsellViewCoordinator: Coordinator {
    weak var delegate: UpsellViewControllerDelegate?
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = UpsellViewModel()
        let viewController = UpsellViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension UpsellViewCoordinator: UpsellViewControllerDelegate {
    func goToCreateWallet() {
        showCreateWallet()
    }

    func goToRecoverWallet() {
        showRestoreWallet()
    }
}
