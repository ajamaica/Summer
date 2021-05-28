//
//  TokenViewCoordinator.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

protocol TokenViewCoordinatorCoordinatorDelegate: AnyObject {

}

class TokenViewCoordinator: Coordinator {
    weak var delegate: TokenViewCoordinatorCoordinatorDelegate?
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = TokenViewModel(solana: applicationComponent.solanaModule.solana)
        let viewController = TokenViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
extension TokenViewCoordinator: TokenViewControllerDelegate {

}
