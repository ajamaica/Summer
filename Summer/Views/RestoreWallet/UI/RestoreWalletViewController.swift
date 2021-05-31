//
//  RestoreWalletViewController.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import UIKit
import RxSwift

protocol RestoreWalletViewControllerDelegate: AnyObject {
    func goToWallet()
}

class RestoreWalletViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var seedPhraseTextField: UITextView!
    let viewModel: RestoreWalletViewModel
    weak var delegate: RestoreWalletViewControllerDelegate?
    init( viewModel: RestoreWalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func customizeMNemonicTextview() {
        seedPhraseTextField.placeholder = "Input Your twelve or twenty-four seed."
        seedPhraseTextField.layer.cornerRadius = 8.7

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Restore Seed Phrase"
        customizeMNemonicTextview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func restoreWallet(_ sender: Any) {
        self.viewModel.restoreWallet(wordlist: self.seedPhraseTextField.text.split { $0 == " " }.map(String.init)).subscribe(onSuccess: {
            self.delegate?.goToWallet()
        }).disposed(by: disposeBag)
    }
}

extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap({ $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap({ $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            textStorage.delegate = self
        }
    }

}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}
