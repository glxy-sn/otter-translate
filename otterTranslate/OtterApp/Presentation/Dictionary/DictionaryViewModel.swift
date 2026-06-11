//
//  DictionaryViewModel.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 06/06/26.
//


import SwiftUI
import Combine

@MainActor
final class DictionaryViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var selectedLetter: String = "#"
    @Published var selectedEntry: JargonEntry?
    @Published var showBanner: Bool = !UserDefaults.standard.bool(
        forKey: Constants.UserDefaultsKey.isKeyboardEnabled
    )
    
    let alphabet: [String] = Constants.Alphabet.letters
    @Published private(set) var entries: [JargonEntry] = []
    
    var filteredEntries: [JargonEntry] {
        let sortedEntries = entries.sorted {
            $0.term.localizedCaseInsensitiveCompare($1.term) == .orderedAscending
        }
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            return sortedEntries
        }
        
        return sortedEntries.filter {
            $0.term.localizedCaseInsensitiveContains(query) ||
            $0.definition.localizedCaseInsensitiveContains(query) ||
            $0.cleanExample.localizedCaseInsensitiveContains(query) ||
            $0.translatedText.localizedCaseInsensitiveContains(query)
        }
    }
    
    init() {
        entries = Self.loadEntriesFromJSON()

        let sortedEntries = entries.sorted {
            $0.term.localizedCaseInsensitiveCompare($1.term) == .orderedAscending
        }
        
        selectedEntry = sortedEntries.first
        selectedLetter = sortedEntries.first?.firstLetter ?? "#"
    }
    
    @discardableResult
    func selectLetter(_ letter: String) -> JargonEntry? {
        selectedLetter = letter
        
        guard let firstMatch = filteredEntries.first(where: { $0.firstLetter == letter }) else {
            return nil
        }
        
        selectedEntry = firstMatch
        return firstMatch
    }
    
    func selectEntry(_ entry: JargonEntry) {
        selectedEntry = entry
        selectedLetter = entry.firstLetter
    }
    
    func updateCenteredEntry(_ entry: JargonEntry) {
        guard selectedEntry?.id != entry.id else { return }
        
        selectedEntry = entry
        selectedLetter = entry.firstLetter
    }
    
    func resetSelectionIfNeeded() {
        guard !filteredEntries.isEmpty else {
            selectedEntry = nil
            return
        }
        
        if let selectedEntry,
           filteredEntries.contains(selectedEntry) {
            selectedLetter = selectedEntry.firstLetter
            return
        }
        
        selectedEntry = filteredEntries.first
        selectedLetter = filteredEntries.first?.firstLetter ?? "A"
    }
    
    func onSetupTapped() {
        print("setup tapped")
    }

    private static func loadEntriesFromJSON() -> [JargonEntry] {
        guard let data = loadDictionaryData(),
              let rawItems = try? JSONDecoder().decode([DictionaryItemDTO].self, from: data) else {
            return JargonEntry.mockList
        }

        let mapped = rawItems.compactMap { item -> JargonEntry? in
            let term = item.term.trimmingCharacters(in: .whitespacesAndNewlines)
            let definition = item.definition.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanExample = item.definition2.trimmingCharacters(in: .whitespacesAndNewlines)
            let translatedText = item.example.trimmingCharacters(in: .whitespacesAndNewlines)

            guard term.isEmpty == false, definition.isEmpty == false else {
                return nil
            }

            return JargonEntry(
                term: term,
                definition: definition,
                indirectExample: cleanExample,
                translatedText: translatedText
            )
        }

        return mapped.isEmpty ? JargonEntry.mockList : mapped
    }

    private static func loadDictionaryData() -> Data? {
        let bundle = Bundle.main

        if let url = bundle.url(forResource: "dict_json", withExtension: "json", subdirectory: "Data"),
           let data = try? Data(contentsOf: url) {
            return data
        }

        if let url = bundle.url(forResource: "dict_json", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            return data
        }

        return nil
    }
}

private struct DictionaryItemDTO: Decodable {
    let term: String
    let definition: String
    let definition2: String
    let example: String

    enum CodingKeys: String, CodingKey {
        case term
        case definition
        case definition2 = "definition_2"
        case example
    }
}
