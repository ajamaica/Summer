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

class WalletTableViewCellViewModel {
    let wallet: SummerWallet
    private let solana: SolanaClient
    init(solana: SolanaClient, wallet: SummerWallet) {
        self.wallet = wallet
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
        self.smalTickerLabel.text = "\(viewModel.wallet.token.symbol)"
        self.tokenNameLabel.text = viewModel.wallet.token.name
        self.tickerLabel.text = "\(viewModel.wallet.token.symbol)"
        self.tokenImage.kf.setImage(with: URL(string: self.viewModel?.wallet.token.logoURI ?? ""))
        self.tokenImage.layer.cornerRadius = 40/2
        self.viewModel?.getTokenBalance(token: viewModel.wallet.pubkey!)
            .subscribe(onSuccess: {
                self.ammountLabel.text = "\($0.uiAmountString ?? $0.amount)"
        }).disposed(by: disposeBag)
    }
}
