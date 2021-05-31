//
//  StartViewModel.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import Foundation
import RxSwift

class StartViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient) {
        self.solana = solana
    }

    func hasAccount() -> Single<String> {
        self.solana.getPublicKey()
    }
}
