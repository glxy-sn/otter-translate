//
//  ShareViewModel.swift
//  OtterSharedExt
//

import Foundation
import Combine

struct ShareEntry: Equatable {
    let inputText: String
    let detectedMatches: [ExactMatchResult]
    let dictionaryEntry: JargonDictionaryEntry?

    var primaryMatch: ExactMatchResult? {
        detectedMatches.first
    }
}

@MainActor
final class ShareViewModel: ObservableObject {
    @Published private(set) var entry: ShareEntry?

    private let matcher = ExactJargonMatcher.shared
    private let dictionary = JargonDictionaryStore.shared

    func setInputText(_ text: String?) {
        guard let cleaned = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              cleaned.isEmpty == false else {
            entry = nil
            return
        }

        let matches = matcher.detectExactTermsWithDetails(in: cleaned)
        let dictionaryEntry = matches.first.flatMap {
            dictionary.entry(forCanonicalId: $0.canonicalId)
        }

        entry = ShareEntry(
            inputText: cleaned,
            detectedMatches: matches,
            dictionaryEntry: dictionaryEntry
        )
    }
}
