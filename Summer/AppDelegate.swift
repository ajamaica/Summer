//
//  AppDelegate.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import UIKit
import SolanaSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appComponent: AppComponent!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let accountStorage = KeychainAccountStorageModule()
        let solana = SolanaModule(endpoint: .testnet, accountStorage: accountStorage)
        appComponent = AppComponent(solanaModule: solana)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

}

class AppComponent {
    let solanaModule: SolanaModule
    init(solanaModule: SolanaModule) {
        self.solanaModule = solanaModule
    }
}
