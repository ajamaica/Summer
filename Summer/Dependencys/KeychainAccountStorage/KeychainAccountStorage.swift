//
//  KeychainAccountStorage.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/19.
//

import Foundation
import KeychainSwift
import Solana

struct KeychainAccountStorageModule: SolanaAccountStorage {
    private let tokenKey = "Summer"
    private let keychain = KeychainSwift()
    
    func save(_ account: Account) -> Result<Void, Error> {
        do {
            let data = try JSONEncoder().encode(account)
            keychain.set(data, forKey: tokenKey)
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    var account: Account? {
        guard let data = keychain.getData(tokenKey) else {return nil}
        return try? JSONDecoder().decode(Account.self, from: data)
    }
    func clear() -> Result<Void, Error> {
        keychain.clear()
        return .success(())
    }
}
