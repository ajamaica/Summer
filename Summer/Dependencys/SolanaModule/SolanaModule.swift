//
//  SolanaModule.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/19.
//

import Foundation
import SolanaSwift

class SolanaModule  {
    private let accountStorage: KeychainAccountStorageModule

    private let endpoint: SolanaEnpoint
    
    var solana: SolanaSDK {
        SolanaSDK(endpoint: SolanaSDK.APIEndPoint(url: endpoint.rawValue, network: .mainnetBeta), accountStorage: self.accountStorage) }
    
    init(endpoint: SolanaEnpoint, accountStorage: KeychainAccountStorageModule) {
        self.accountStorage = accountStorage
        self.endpoint = endpoint
    }
}

enum SolanaEnpoint: String {
    case mainnetBeta = "https://api.mainnet-beta.solana.com"
    case devnet = "https://api.devnet.solana.com"
    case testnet = "https://api.testnet.solana.com"
}
