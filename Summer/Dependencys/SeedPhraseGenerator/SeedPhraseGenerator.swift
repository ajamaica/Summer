//
//  SeedPhraseGenerator.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/05/22.
//

import Foundation
import Solana

typealias SeedPhraseCollection = [String]

protocol SeedPhrase {
    func isValid(wordlist: [String]) -> Bool
    func getSeedPhrase() -> SeedPhraseCollection
}

class ConcreteSeedPhrase: SeedPhrase {
    private var seedPhase: SeedPhraseCollection?
    private func createSeedFrase(strength: Int = 256,
                         wordlist: [String] = Wordlists.english) -> [String] {
        let mnemonic = Mnemonic(strength: strength, wordlist: wordlist)
        return mnemonic.phrase
    }

    func isValid(wordlist: [String]) -> Bool {
        return Mnemonic.isValid(phrase: wordlist)
    }

    func getSeedPhrase() -> SeedPhraseCollection {
        guard let _seedPhase = seedPhase else {
            seedPhase = createSeedFrase()
            return getSeedPhrase()
        }
        return _seedPhase
    }
}
