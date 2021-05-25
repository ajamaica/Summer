//
//  Token.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

public protocol Token: Hashable, Decodable {
    associatedtype TT: TokenTag
    associatedtype TE: TokenExtensions
    var chainId: Int { get }
    var address: String { get }
    var symbol: String { get }
    var name: String { get }
    var decimals: UInt8 { get }
    var logoURI: String? { get }
    var tags: [TT] { get }
    var extensions: TE? { get }
}

struct SummerToken: Token {

    let _tags: [String]
    let chainId: Int
    let address: String
    let symbol: String
    let name: String
    let decimals: UInt8
    let logoURI: String?
    var tags: [SummerTokenTag] = []
    let extensions: SummerTokenExtensions?

    public init(_tags: [String], chainId: Int, address: String, symbol: String, name: String, decimals: UInt8, logoURI: String?, tags: [SummerTokenTag] = [], extensions: SummerTokenExtensions?) {
        self._tags = _tags
        self.chainId = chainId
        self.address = address
        self.symbol = symbol
        self.name = name
        self.decimals = decimals
        self.logoURI = logoURI
        self.tags = tags
        self.extensions = extensions
    }

    enum CodingKeys: String, CodingKey {
        case chainId, address, symbol, name, decimals, logoURI, extensions, _tags = "tags"
    }

    public var wrappedBy: WrappingToken? {
        if tags.contains(where: {$0.name == "wrapped-sollet"}) {
            return .sollet
        }

        if tags.contains(where: {$0.name == "wrapped"}) &&
            tags.contains(where: {$0.name == "wormhole"}) {
            return .wormhole
        }

        return nil
    }
}
