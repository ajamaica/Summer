//
//  SolanaModule.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/19.
//

import Foundation
import RxSwift

protocol SolanaClient {
    func deleteAccount(completition: @escaping((Result<(), Error>)-> ()))
    func createAccount(withPhrase: SeedPhraseCollection, completition: @escaping((Result<(), Error>)-> ()))
    func getBalance(completition: @escaping(Result<UInt64, Error>) -> ())
    func getPublicKey(completition: @escaping(Result<String, Error>) -> ())
    func sendSPL(mintAddress: String, decimals: UInt8, from: String, to: String, amount: UInt64, completition: @escaping(Result<String, Error>) -> ())
    func getTokenWallets(completition: @escaping(Result<[SummerWallet], Error>) -> ())
    func addToken(mintAddress: String, completition: @escaping(Result<(signature: String, newPubkey: String), Error>) -> ())
    func getTokenAccountBalance(token: String, completition: @escaping(Result<SolanaSDK.TokenAccountBalance, Error>) -> ())

}

class SolanaModule  {
    let solana: SolanaClient
    init(solana: SolanaClient){
        self.solana = solana
    }
}

enum SolanaClientError: Error {
    case accountNotSet
}

enum SolanaEnpoint: String {
    case mainnetBeta = "https://api.mainnet-beta.solana.com"
    case devnet = "https://api.devnet.solana.com"
    case testnet = "https://api.testnet.solana.com"
}

class ConcreteSolanaClient: SolanaClient {
    private let accountStorage: KeychainAccountStorageModule
    private let endpoint: SolanaEnpoint
    private let disposeBag =  DisposeBag()
    
    let network: SolanaSDK.Network
    
    var solana: SolanaSDK {
        SolanaSDK(endpoint: SolanaSDK.APIEndPoint(url: self.endpoint.rawValue, network: self.network), accountStorage: self.accountStorage) }
    
    init(endpoint: SolanaEnpoint, network: SolanaSDK.Network, accountStorage: KeychainAccountStorageModule) {
        self.network = network
        self.accountStorage = accountStorage
        self.endpoint = endpoint
    }
    
    func deleteAccount(completition: @escaping((Result<(), Error>)-> ())) {
        do {
            let _ = try getAccount().get()
            self.solana.accountStorage.clear()
            return completition(.success(()))
        } catch let e {
            return completition(.failure(e))
        }
    }
    
    func createAccount(withPhrase: SeedPhraseCollection, completition: @escaping((Result<(), Error>)-> ())) {
        do {
            var network: SolanaSDK.Network!
            switch endpoint {
            case .mainnetBeta:
                network = .mainnetBeta
            case .devnet:
                network = .devnet
            case .testnet:
                network = .testnet
            }
            let account = try SolanaSDK.Account(phrase: withPhrase, network: network, derivablePath: .default)
            try self.solana.accountStorage.save(account)
            return completition(.success(()))
        } catch let e {
            return completition(.failure(e))
        }
    }
    
    func getBalance(completition: @escaping(Result<UInt64, Error>) -> ()) {
        do{
            let account = try getAccount().get()
            self.solana.getBalance(account: account.publicKey.base58EncodedString, commitment: "recent")
                .subscribe { balance in
                    completition(.success(balance))
            }
            .disposed(by: disposeBag)
        } catch let e {
            completition(.failure(e))
        }
    }
    
    private func getAccount() -> Result<SolanaSDK.Account, SolanaClientError> {
        if let account = self.solana.accountStorage.account {
            return .success(account)
        } else {
            return .failure(.accountNotSet)
        }
    }
    
    func getPublicKey(completition: @escaping(Result<String, Error>) -> ()){
        do{
            let account = try getAccount().get()
            return completition(.success(account.publicKey.base58EncodedString))
        } catch let e {
            completition(.failure(e))
        }
    }
    
    func sendSOL(to: String, amount: UInt64, completition: @escaping(Result<String, Error>) -> ()){
        do{
            let _ = try getAccount().get()
            self.solana.sendSOL(to: to, amount: amount).subscribe { balance in
                completition(.success(balance))
            }
            .disposed(by: disposeBag)
        } catch let e {
            completition(.failure(e))
        }
    }
    
    func sendSPL(mintAddress: String,
                 decimals: UInt8,
                 from: String,
                 to: String,
                 amount: UInt64,
                 completition: @escaping(Result<String, Error>) -> ()){
        do{
            let _ = try getAccount().get()
            self.solana.sendSPLTokens(mintAddress: mintAddress, decimals: decimals, from: from, to: to, amount: amount)
                .subscribe { balance in
                completition(.success(balance))
            }
            .disposed(by: disposeBag)
        } catch let e {
            completition(.failure(e))
        }
    }
    
    func getTokenWallets(completition: @escaping(Result<[SummerWallet], Error>) -> ()) {
        do{
            let account = try getAccount().get()
            self.solana.getTokenWallets(account: account.publicKey.base58EncodedString)
                .map {
                    return $0
                        .map {
                        let extensions = SummerTokenExtensions(website: $0.token.extensions?.website, bridgeContract: $0.token.extensions?.bridgeContract)
                        let token = SummerToken(_tags: [], chainId: $0.token.chainId, address: $0.token.address, symbol: $0.token.symbol, name: $0.token.name, decimals: $0.token.decimals, logoURI: $0.token.logoURI, extensions: extensions)
                        return SummerWallet(pubkey: $0.pubkey, lamports: $0.lamports, token: token, liquidity: $0.isLiquidity)
                    }
                }
                .subscribe { result in
                    completition(.success(result))
                }
            .disposed(by: disposeBag)
        } catch let e {
            completition(.failure(e))
        }
    }
    
    func getTokenAccountBalance(token: String, completition: @escaping(Result<SolanaSDK.TokenAccountBalance, Error>) -> ()) {
        do{
            let _ = try getAccount().get()
            self.solana.getTokenAccountBalance(pubkey: token)
                .subscribe {
                completition($0)
            }
            .disposed(by: disposeBag)
        } catch let e {
            completition(.failure(e))
        }
    }
    
    func addToken(mintAddress: String, completition: @escaping(Result<(signature: String, newPubkey: String), Error>) -> ()) {
        do{
            let _ = try getAccount().get()
            self.solana.createTokenAccount(mintAddress: mintAddress)
                .subscribe { result in
                completition(.success(result))
            }
            .disposed(by: disposeBag)
        } catch let e {
            completition(.failure(e))
        }
    }
}

public enum WrappingToken: String {
    case sollet, wormhole
}
