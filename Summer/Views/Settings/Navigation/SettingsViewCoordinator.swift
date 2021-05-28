//
//  SettingsViewCoordinator.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

protocol SettingsViewCoordinatorDelegate: AnyObject { }

class SettingsViewCoordinator: Coordinator {
    weak var delegate: SettingsViewCoordinatorDelegate?
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = SettingsViewModel(solana: applicationComponent.solanaModule.solana)
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SettingsViewCoordinator: SettingsViewControllerDelegate {
    func logout() {
        showStart()
    }

}
