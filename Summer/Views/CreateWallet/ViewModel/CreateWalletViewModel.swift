//
//  CreateWalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation

class CreateWalletViewModel {
    private var seedPhrase = ConcreteSeedPhrase()
    private let solana: SolanaClient
    init(solana: SolanaClient) {
        self.solana = solana
    }
    func getSeedPhrase() -> SeedPhraseCollection {
        seedPhrase.getSeedPhrase()
    }

    func createWallet(completition: @escaping((Result<(), Error>)-> Void)) {
        solana.createAccount(withPhrase: getSeedPhrase(), completition: completition)
    }
}
