//
//  Coordinator.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import Foundation
import UIKit

class Coordinator {
    let applicationComponent: AppComponent
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    init(applicationComponent: AppComponent, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.applicationComponent = applicationComponent
    }

    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func dismissModal() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func boot(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.showStart()
        return window
    }
    
    func showStart() {
        self.navigationController?.popToRootViewController(animated: false)
        let coordinator = StartViewCoordinator(applicationComponent: applicationComponent, navigationController: navigationController)
        coordinator.start()
        childCoordinators = [coordinator]
    }
    
    func showUpsell() {
        let coordinator = UpsellViewCoordinator(applicationComponent: applicationComponent, navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func showCreateWallet() {
        let coordinator = CreateWalletCoordinator(applicationComponent: applicationComponent, navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func showWallet() {
        let coordinator = WalletCoordinator(applicationComponent: applicationComponent, navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func showRestoreWallet() {
        let coordinator = RestoreWalletCoordinator(applicationComponent: applicationComponent, navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func showSettings() {
        let coordinator = SettingsViewCoordinator(applicationComponent: applicationComponent, navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
