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
        let viewModel = StartViewModel()
        let viewController = StartViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension StartViewCoordinator: StartViewControllerDelegate {
    func goToStartUpsell() {
        
    }
}
