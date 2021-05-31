//
//  RestoreWalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation
import RxSwift

enum RestoreWalletViewModelError: Error {
    case invalidSeed
}
class RestoreWalletViewModel {
    private let solana: SolanaClient
    private var seedPhrase = ConcreteSeedPhrase()
    init(solana: SolanaClient) {
        self.solana = solana
    }

    func restoreWallet(wordlist: [String]) -> Single<Void> {
        guard seedPhrase.isValid(wordlist: wordlist) == true else {
            return Single.error(RestoreWalletViewModelError.invalidSeed)
        }
        return solana.createAccount(withPhrase: wordlist)
    }
}
