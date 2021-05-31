//
//  SolanaModule.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/19.
//

import Foundation
import RxSwift
import Solana

protocol SolanaClient {
    func deleteAccount() -> Single<Void>
    func createAccount(withPhrase: SeedPhraseCollection) -> Single<Void>
    func getBalance() -> Single<UInt64>
    func getPublicKey() -> Single<String>
    func sendSPL(mintAddress: String, decimals: UInt8, from: String, to: String, amount: UInt64) -> Single<String>
    func getTokenWallets() -> Single<[SummerWallet]>
    func addToken(mintAddress: String) -> Single<(signature: String, newPubkey: String)>
    func getTokenAccountBalance(token: String) -> Single<SummerTokenAccountBalance>
}

class SolanaModule {
    let solana: SolanaClient
    init(solana: SolanaClient) {
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

    let network: Solana.Network

    var solana: Solana {
        Solana(endpoint: Solana.RpcApiEndPoint.devnetSolana, accountStorage: self.accountStorage) }

    init(endpoint: SolanaEnpoint, network: Solana.Network, accountStorage: KeychainAccountStorageModule) {
        self.network = network
        self.accountStorage = accountStorage
        self.endpoint = endpoint
    }

    func deleteAccount() -> Single<Void>  {
        return self.getAccount().flatMap { account in
            return .just(self.solana.accountStorage.clear())
        }
    }

    func createAccount(withPhrase: SeedPhraseCollection) -> Single<Void> {
        do {
            var network: Solana.Network!
            switch endpoint {
            case .mainnetBeta:
                network = .mainnetBeta
            case .devnet:
                network = .devnet
            case .testnet:
                network = .testnet
            }
            let account = try Solana.Account(phrase: withPhrase, network: network, derivablePath: .default)
            try self.solana.accountStorage.save(account)
            return Single.just(())
        } catch let e {
            return Single.error(e)
        }
    }

    func getBalance() -> Single<UInt64> {
        return self.getAccount().flatMap { account in
             self.solana.getBalance(account: account.publicKey.base58EncodedString, commitment: "recent")
        }
    }

    private func getAccount() -> Single<Solana.Account> {
        if let account = self.solana.accountStorage.account {
            return .just(account)
        } else {
            return .error(SolanaClientError.accountNotSet)
        }
    }

    func getPublicKey() -> Single<String> {
        return self.getAccount().map { account in
            account.publicKey.base58EncodedString
        }
    }

    func sendSOL(to: String, amount: UInt64) -> Single<String> {
        return self.getAccount().flatMap { account in
            self.solana.sendSOL(to: to, amount: amount)
        }
    }

    func sendSPL(mintAddress: String,
                 decimals: UInt8,
                 from: String,
                 to: String,
                 amount: UInt64) -> Single<String> {
        
        return self.getAccount().flatMap { account in
            self.solana.sendSPLTokens(mintAddress: mintAddress, decimals: decimals, from: from, to: to, amount: amount)
        }
    }

    func getTokenWallets() -> Single<[SummerWallet]> {
        return self.getAccount().flatMap { account in
            self.solana.getTokenWallets(account: account.publicKey.base58EncodedString)
        }.map{
            return $0
                .map {
                let extensions = SummerTokenExtensions(website: $0.token.extensions?.website, bridgeContract: $0.token.extensions?.bridgeContract)
                let token = SummerToken(_tags: [], chainId: $0.token.chainId, address: $0.token.address, symbol: $0.token.symbol, name: $0.token.name, decimals: $0.token.decimals, logoURI: $0.token.logoURI, extensions: extensions)
                return SummerWallet(pubkey: $0.pubkey, lamports: $0.lamports, token: token, liquidity: $0.isLiquidity)
            }
        }
    }

    func getTokenAccountBalance(token: String) -> Single<SummerTokenAccountBalance> {
        return self.getAccount().flatMap { account in
            self.solana.getTokenAccountBalance(pubkey: token).map{
                SummerTokenAccountBalance(uiAmount: $0.uiAmount, amount: $0.amount, decimals: $0.decimals, uiAmountString: $0.uiAmountString)
            }
        }
    }

    func addToken(mintAddress: String) -> Single<(signature: String, newPubkey: String)> {
        return self.getAccount().flatMap { account in
            self.solana.createTokenAccount(mintAddress: mintAddress)
        }
    }
}

public enum WrappingToken: String {
    case sollet, wormhole
}


