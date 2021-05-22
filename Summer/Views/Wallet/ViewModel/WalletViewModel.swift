//
//  WalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation

class WalletViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient){
        self.solana = solana
    }
}
