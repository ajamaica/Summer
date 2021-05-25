//
//  WalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation

enum WalletViewModelState {
    case updatingWallet
    case updatedWallets([SummerWallet])
}

class WalletViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient) {
        self.solana = solana
    }

    func getAddress(completition: @escaping(Result<String, Error>) -> Void) {
        self.solana.getPublicKey(completition: completition)
    }

    func getBalance(completition: @escaping(Result<UInt64, Error>) -> Void) {
        self.solana.getBalance(completition: completition)
    }

    func getTokenBalance(token: String, completition: @escaping(Result<Solana.TokenAccountBalance, Error>) -> Void) {
        self.solana.getTokenAccountBalance(token: token, completition: completition)
    }

    func getTokenWallets(completition: @escaping(Result<[SummerWallet], Error>) -> Void) {
        self.solana.getTokenWallets(completition: completition)
    }

}
