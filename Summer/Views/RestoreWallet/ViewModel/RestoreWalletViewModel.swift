//
//  RestoreWalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

enum RestoreWalletViewModelError: Error {
    case invalidSeed
}
class RestoreWalletViewModel {
    private let solana: SolanaClient
    private var seedPhrase = ConcreteSeedPhrase()
    init(solana: SolanaClient) {
        self.solana = solana
    }

    func restoreWallet(wordlist: [String], completition: @escaping ((Result<(), Error>) -> Void)) {
        guard seedPhrase.isValid(wordlist: wordlist) == true else {
            return completition(.failure(RestoreWalletViewModelError.invalidSeed))
        }
        solana.createAccount(withPhrase: wordlist, completition: completition)
    }
}
