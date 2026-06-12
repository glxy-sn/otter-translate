//
//  ShareModels.swift
//  OtterSharedExt
//

import Foundation

struct ShareTermDetail: Equatable, Identifiable {
    let id: String
    let match: ExactMatchResult
    let dictionaryEntry: JargonDictionaryEntry?
}

struct ShareEntry: Equatable {
    let inputText: String
    let termDetails: [ShareTermDetail]
}
