//
//  StartViewModel.swift
//  Solem
//
//  Created by Arturo Jamaica on 2021/05/17.
//

import Foundation

class StartViewModel {
    private let solana: SolanaClient
    init(solana: SolanaClient) {
        self.solana = solana
    }

    func hasAccount(completition: @escaping(Result<Void, Error>) -> Void) {
        self.solana.getPublicKey { result in
            switch result {
            case .success:
                completition(.success(()))
            case .failure(let error):
                completition(.failure(error))
            }
        }
    }
}
