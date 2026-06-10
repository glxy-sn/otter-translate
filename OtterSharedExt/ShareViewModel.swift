//
//  ShareViewModel.swift
//  OtterSharedExt
//

import Foundation
import Combine

struct ShareEntry: Equatable {
    let term: String
}

@MainActor
final class ShareViewModel: ObservableObject {
    @Published private(set) var entry: ShareEntry?

    func setInputText(_ text: String?) {
        guard let cleaned = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              cleaned.isEmpty == false else {
            entry = nil
            return
        }
        entry = ShareEntry(term: cleaned)
    }
}
