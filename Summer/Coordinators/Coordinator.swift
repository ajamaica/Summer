//
//  Coordinator.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import Foundation
import UIKit

class Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
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
        let coordinator = StartViewCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func showUpsell() {
        let coordinator = UpsellViewCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
