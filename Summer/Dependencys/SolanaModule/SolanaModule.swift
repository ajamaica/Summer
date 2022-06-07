//
//  SolanaModule.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/19.
//

import Foundation
import RxSwift
import Solana
import RxSolana

protocol SolanaClient {
    func deleteAccount() -> Single<Void>
    func createAccount(withPhrase: SeedPhraseCollection) -> Single<Void>
    func getBalance() -> Single<UInt64>
    func getPublicKey() -> Single<String>
    func sendSPL(mintAddress: String, from: String, to: String, amount: UInt64) -> Single<String>
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
    private let endpoint: RPCEndpoint
    private let disposeBag =  DisposeBag()

    let network = NetworkingRouter(endpoint: .devnetSolana)

    var solana: Solana {
        Solana(router: network)
    }

    init(endpoint: RPCEndpoint, accountStorage: KeychainAccountStorageModule) {
        self.accountStorage = accountStorage
        self.endpoint = endpoint
    }

    func deleteAccount() -> Single<Void>  {
        Single.create { emitter in
            emitter(self.accountStorage.clear())
            return Disposables.create()
        }
    }

    func createAccount(withPhrase: SeedPhraseCollection) -> Single<Void> {
        Single.create { emitter in
            let account = Account(phrase: withPhrase, network: self.endpoint.network, derivablePath: .default)!
            emitter(self.accountStorage.save(account))
            return Disposables.create()
        }
        
    }

    func getBalance() -> Single<UInt64> {
        return self.getAccount().flatMap { account in
            self.solana.api.getBalance(account: account.publicKey.base58EncodedString, commitment: "recent")
        }
    }

    private func getAccount() -> Single<Account> {
        guard let account = try? self.accountStorage.account.get() else {
            return .error(SolanaClientError.accountNotSet)
        }
        return .just(account)
    }

    func getPublicKey() -> Single<String> {
        return self.getAccount().map { account in
            account.publicKey.base58EncodedString
        }
    }

    func sendSOL(to: String, amount: UInt64) -> Single<String> {
        return self.getAccount().flatMap { account in
            self.solana.action.sendSOL(to: to, from: account, amount: amount)
        }
    }

    func sendSPL(mintAddress: String,
                 from: String,
                 to: String,
                 amount: UInt64) -> Single<String> {
        
        return self.getAccount().flatMap { account in
            self.solana.action.sendSPLTokens(mintAddress: mintAddress, from: from, to: to, amount: amount, payer: account)
        }
    }

    func getTokenWallets() -> Single<[SummerWallet]> {
        return self.getAccount().flatMap { account in
            self.solana.action.getTokenWallets(account: account.publicKey.base58EncodedString)
        }.map {
            return $0
                .map {
                    let extensions = SummerTokenExtensions(website: $0.token?.extensions?.website, bridgeContract: $0.token?.extensions?.bridgeContract)
                    let token = SummerToken(_tags: [], chainId: $0.token?.chainId, address: $0.token!.address, symbol: $0.token?.symbol, name: $0.token?.name, decimals: $0.ammount?.decimals ?? 0, logoURI: $0.token?.logoURI, extensions: extensions)
                return SummerWallet(pubkey: $0.pubkey, token: token, liquidity: $0.isLiquidity)
            }
        }
    }

    func getTokenAccountBalance(token: String) -> Single<SummerTokenAccountBalance> {
        return self.getAccount().flatMap { account in
            self.solana.api.getTokenAccountBalance(pubkey: token).map{
                SummerTokenAccountBalance(uiAmount: $0.uiAmount, amount: $0.amount, decimals: $0.decimals, uiAmountString: $0.uiAmountString)
            }
        }
    }

    func addToken(mintAddress: String) -> Single<(signature: String, newPubkey: String)> {
        return self.getAccount().flatMap { account in
            self.solana.action.createTokenAccount(mintAddress: mintAddress, payer: account)
        }
    }
}

public enum WrappingToken: String {
    case sollet, wormhole
}


