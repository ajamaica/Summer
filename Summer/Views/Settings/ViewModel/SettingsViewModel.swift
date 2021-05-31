//
//  SettingsViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation
import RxSwift

class SettingsViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient) {
        self.solana = solana
    }

    func logout() -> Single<Void> {
        self.solana.deleteAccount()
    }
}
