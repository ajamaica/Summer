//
//  TokenViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

class TokenViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient) {
        self.solana = solana
    }
}
