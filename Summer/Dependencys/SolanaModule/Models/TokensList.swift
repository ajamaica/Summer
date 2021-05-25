//
//  TokensList.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

protocol TokensList: Decodable {
    associatedtype T: Token
    associatedtype TT: TokenTag
    var name: String { get }
    var logoURI: String { get }
    var keywords: [String] { get }
    var tags: [String: TT] { get }
    var timestamp: String { get }
    var tokens: [T] { get }
}

struct SummerTokensList: TokensList {
    let name: String
    let logoURI: String
    let keywords: [String]
    let tags: [String: SummerTokenTag]
    let timestamp: String
    var tokens: [SummerToken]
}
