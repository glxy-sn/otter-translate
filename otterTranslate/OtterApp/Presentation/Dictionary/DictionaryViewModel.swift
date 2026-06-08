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
    let entries: [JargonEntry] = JargonEntry.mockList
    
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
            $0.example.localizedCaseInsensitiveContains(query)
        }
    }
    
    init() {
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
}
