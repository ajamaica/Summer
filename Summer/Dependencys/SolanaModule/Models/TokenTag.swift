//
//  TokenTag.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/23.
//

import Foundation

public protocol TokenTag: Hashable, Decodable {
    var name: String { get }
    var description: String { get }
}

struct SummerTokenTag: TokenTag {
    var name: String
    var description: String
}
