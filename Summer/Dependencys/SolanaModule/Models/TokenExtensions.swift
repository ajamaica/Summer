//
//  TokenExtensions.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

public protocol TokenExtensions: Hashable, Decodable {
    var website: String? { get }
    var bridgeContract: String? { get }
}

struct SummerTokenExtensions: TokenExtensions {
    var website: String?
    var bridgeContract: String?
}
