//
//  WalletHeader.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import UIKit

class WalletHeaderView: UIView {

    @IBOutlet weak var nftsButton: UIButton!
    @IBOutlet weak var tokensButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var ammountLabel: UILabel!

}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
