//
//  SolanaTokenAccountBalance.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/31.
//

import Foundation

public protocol TokenAccountBalance: Codable, Hashable {
    var uiAmount: Float64? { get }
    var amount: String { get }
    var decimals: UInt8? { get }
    var uiAmountString: String? { get }
    var amountInUInt64: UInt64? { get }
}

struct SummerTokenAccountBalance: TokenAccountBalance {
    init(uiAmount: Float64?, amount: String, decimals: UInt8?, uiAmountString: String?) {
        self.uiAmount = uiAmount
        self.amount = amount
        self.decimals = decimals
        self.uiAmountString = uiAmountString
    }

    public let uiAmount: Float64?
    public let amount: String
    public let decimals: UInt8?
    public let uiAmountString: String?

    public var amountInUInt64: UInt64? {
        return UInt64(amount)
    }
}
