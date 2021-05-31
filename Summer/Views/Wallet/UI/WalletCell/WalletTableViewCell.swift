//
//  WalletTableViewCell.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import UIKit
import RxSwift
import Solana
import Kingfisher

enum TokenType {
    case solana(String)
    case token(SummerWallet)
}

class WalletTableViewCellViewModel {
    let tokenType: TokenType
    private let solana: SolanaClient
    init(solana: SolanaClient, tokenType: TokenType) {
        self.tokenType = tokenType
        self.solana = solana
    }
    
    func getBalance() -> Single<UInt64> {
        return self.solana.getBalance()
    }

    func getTokenBalance(token: String) -> Single<SummerTokenAccountBalance> {
        return self.solana.getTokenAccountBalance(token: token)
    }

}

class WalletTableViewCell: UITableViewCell {

    let disposeBag = DisposeBag()
    @IBOutlet weak var smalTickerLabel: UILabel!
    private var viewModel: WalletTableViewCellViewModel?
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    @IBOutlet weak var fiatValueLabel: UILabel!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    
    func setViewModel(_ viewModel: WalletTableViewCellViewModel){
        self.viewModel = viewModel
        
        switch viewModel.tokenType {
        case .solana(let address):
            setSOLUI(address: address)
        case .token(let wallet):
            setTokenUI(wallet: wallet)
        }
        
    }
    
    private func setSOLUI(address: String){
        self.smalTickerLabel.text = "SOL"
        self.tokenNameLabel.text = "Solana"
        self.tickerLabel.text = "SOL"
        self.tokenImage.image = UIImage(named: "tokenLogo")
        self.tokenImage.layer.cornerRadius = 40/2
        self.viewModel?.getBalance()
            .subscribe(onSuccess: {
                self.ammountLabel.text = "\(Double($0)/pow(10.0,9.0))"
        }).disposed(by: disposeBag)
    }
    
    private func setTokenUI(wallet: SummerWallet){
        self.smalTickerLabel.text = "\(wallet.token.symbol)"
        self.tokenNameLabel.text = wallet.token.name
        self.tickerLabel.text = "\(wallet.token.symbol)"
        self.tokenImage.kf.setImage(with: URL(string: wallet.token.logoURI ?? ""))
        self.tokenImage.layer.cornerRadius = 40/2
        self.viewModel?.getTokenBalance(token: wallet.pubkey!)
            .subscribe(onSuccess: {
                self.ammountLabel.text = "\($0.uiAmountString ?? $0.amount)"
        }).disposed(by: disposeBag)
    }
}
