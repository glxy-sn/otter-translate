//
//  ShareViewModel.swift
//  OtterSharedExt
//

import Foundation
import Combine

struct ShareTermDetail: Equatable, Identifiable {
    let id: String
    let match: ExactMatchResult
    let dictionaryEntry: JargonDictionaryEntry?
}

struct ShareEntry: Equatable {
    let inputText: String
    let termDetails: [ShareTermDetail]
}

@MainActor
final class ShareViewModel: ObservableObject {
    @Published private(set) var entry: ShareEntry?
    @Published var selectedTermIndex: Int = 0

    private let matcher = ExactJargonMatcher.shared
    private let dictionary = JargonDictionaryStore.shared

    func setInputText(_ text: String?) {
        guard let cleaned = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              cleaned.isEmpty == false else {
            entry = nil
            selectedTermIndex = 0
            return
        }

        let matches = matcher
            .detectExactTermsWithDetails(in: cleaned)
            .sorted { $0.start < $1.start }

        let termDetails = matches.map { match in
            ShareTermDetail(
                id: match.id,
                match: match,
                dictionaryEntry: dictionary.entry(forCanonicalId: match.canonicalId)
            )
        }

        entry = ShareEntry(inputText: cleaned, termDetails: termDetails)
        selectedTermIndex = 0
    }
}
