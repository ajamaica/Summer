//
//  WalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation
import Solana
import RxSwift


class WalletViewModel {
    let solana: SolanaClient

    init(solana: SolanaClient) {
        self.solana = solana
    }

    func getAddress() -> Single<String> {
        return self.solana.getPublicKey()
    }

    func getTokenWallets() -> Single<[SummerWallet]> {
        return self.solana.getTokenWallets()
    }

}
