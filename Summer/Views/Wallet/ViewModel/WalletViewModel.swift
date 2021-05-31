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

    func getSolanaWallet() -> Single<SummerWallet> {
        return self.solana.getPublicKey().map {
            SummerWallet.nativeSolana(pubkey: $0, lamport: nil)
        }
    }

    func getTokenWallets() -> Single<[SummerWallet]> {
        return getSolanaWallet().flatMap { solanaWallet in
            return self.solana.getTokenWallets().map {
                return [solanaWallet] + $0
            }
        }
    }
}
