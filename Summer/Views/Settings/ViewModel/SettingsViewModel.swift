//
//  SettingsViewModel.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

class SettingsViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient){
        self.solana = solana
    }
    
    func logout(completition: @escaping ((Result<(), Error>) -> ())){
        self.solana.deleteAccount(completition: completition)
    }
}
