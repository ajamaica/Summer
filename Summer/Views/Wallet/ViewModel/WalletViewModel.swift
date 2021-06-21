//
//  WalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation
import Solana
import RxSwift

enum NFTType: String{
    case gif
    case usdz
}
struct NFT {
    let url: URL
    let name: String
    let type: NFTType
}

fileprivate let nfts: [NFT] = [
    NFT(url: Bundle.main.url(forResource: "solanashue", withExtension: "usdz")!, name: "Solana Sneakers",  type: .usdz),
    NFT(url: Bundle.main.url(forResource: "solana_bot", withExtension: "gif")!, name: "Solarian",  type: .gif)
]

class WalletViewModel {
    let solana: SolanaClient

    init(solana: SolanaClient) {
        self.solana = solana
    }
    
    func getNFTs() -> Single<[NFT]> {
        return .just(nfts)
    }

    private func getSolanaWallet() -> Single<SummerWallet> {
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
