//
//  WalletViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import UIKit

protocol WalletViewControllerDelegate: AnyObject {
    func goToSettings()
    func goToToken()
    
}
let WalletTableViewCellIdentifier = "WalletTableViewCell"
class WalletViewController: UIViewController {

    @IBOutlet weak var walletTableView: UITableView!
    var headerView: WalletHeaderView!
    var footerView: FooterView!
    let viewModel: WalletViewModel
    weak var delegate: WalletViewControllerDelegate?
    init( viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = walletTableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                walletTableView.tableHeaderView = headerView
            }
        }
        if let footerView = walletTableView.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var footerFrame = footerView.frame
            if height != footerFrame.size.height {
                footerFrame.size.height = height
                footerView.frame = footerFrame
                walletTableView.tableHeaderView = footerView
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = .fromNib()
        footerView = .fromNib()
        headerView.settingsButton.addTarget(self, action: #selector(settingsAction(sender:)), for: .touchUpInside)
        walletTableView.tableHeaderView = headerView
        walletTableView.tableFooterView = footerView
        walletTableView.delegate = self
        walletTableView.dataSource = self
        walletTableView.register(UINib(nibName: WalletTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: WalletTableViewCellIdentifier)
        walletTableView.contentInsetAdjustmentBehavior = .never
        
        
        self.viewModel.getTokenWallets { result in
            switch result {
            case .success(let wallets):
                debugPrint(wallets)
                wallets.forEach { wallet in
                    self.viewModel.getTokenBalance(token: wallet.pubkey!) { result2 in
                        switch result2{
                        case .success(let r):
                            debugPrint(r)
                        case .failure(_):
                            break
                        }
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    @objc
    func settingsAction(sender: UIButton){
        delegate?.goToSettings()
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: WalletTableViewCellIdentifier, for: indexPath)
    }
}
