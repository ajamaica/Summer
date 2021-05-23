//
//  WalletViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation
import SolanaSwift

class WalletViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient){
        self.solana = solana
    }
    
    func getAddress(completition: @escaping(Result<String, Error>) -> ()){
        self.solana.getPublicKey(completition: completition)
    }
    
    func getBalance(completition: @escaping(Result<UInt64, Error>) -> ()){
        self.solana.getBalance(completition: completition)
    }
    
    func getWallets(completition: @escaping(Result<[SolanaSDK.Wallet], Error>) -> ()){
        self.solana.getSPLTokens(completition: completition)
    }
    
}
