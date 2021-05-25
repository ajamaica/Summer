//
//  KeychainAccountStorage.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/19.
//

import Foundation
import KeychainSwift

struct KeychainAccountStorageModule: SolanaSDKAccountStorage {
    private let tokenKey = "Summer"
    private let keychain = KeychainSwift()
    func save(_ account: SolanaSDK.Account) throws {
        let data = try JSONEncoder().encode(account)
        keychain.set(data, forKey: tokenKey)
    }
    
    var account: SolanaSDK.Account? {
        guard let data = keychain.getData(tokenKey) else {return nil}
        return try? JSONDecoder().decode(SolanaSDK.Account.self, from: data)
    }
    func clear() {
        keychain.clear()
    }
}
