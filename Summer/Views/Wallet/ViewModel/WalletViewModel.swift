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
    init(solana: SolanaClient){
        self.solana = solana
    }
    
    func getAddress(completition: @escaping(Result<String, Error>) -> ()){
        self.solana.getPublicKey(completition: completition)
    }
    
    func getBalance(completition: @escaping(Result<UInt64, Error>) -> ()){
        self.solana.getBalance(completition: completition)
    }
    
    func getTokenBalance(token: String, completition: @escaping(Result<SolanaSDK.TokenAccountBalance, Error>) -> ()){
        self.solana.getTokenAccountBalance(token: token, completition: completition)
    }
    
    func getTokenWallets(completition: @escaping(Result<[SummerWallet], Error>) -> ()){
        self.solana.getTokenWallets(completition: completition)
    }
    
}
