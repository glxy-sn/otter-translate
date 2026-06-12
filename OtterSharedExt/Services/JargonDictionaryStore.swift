//
//  JargonDictionaryStore.swift
//  OtterSharedExt
//

import Foundation

struct JargonDictionaryEntry: Equatable {
    let definition: String
    let indirectExample: String
    let translatedExample: String
}

enum JargonDictionaryStoreError: LocalizedError {
    case missingResource(String)
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            return "Could not find \(name) in the app bundle."
        case .decodingFailed(let message):
            return "Failed to decode dictionary JSON: \(message)"
        }
    }
}

final class JargonDictionaryStore {
    static let shared: JargonDictionaryStore = {
        do {
            return try JargonDictionaryStore()
        } catch {
            NSLog("JargonDictionaryStore.shared failed to load: \(error.localizedDescription)")
            return JargonDictionaryStore(entriesByCanonicalId: [:], loadError: error)
        }
    }()

    private(set) var loadError: Error?
    private let entriesByCanonicalId: [String: JargonDictionaryEntry]

    init(bundle: Bundle = .main) throws {
        let dictionaryItems = try Self.loadDictionaryItems(bundle: bundle)
        let matcherPatterns = try Self.loadMatcherPatterns(bundle: bundle)

        var indexed: [String: JargonDictionaryEntry] = [:]

        for pattern in matcherPatterns {
            let canonicalId = pattern.canonicalId
            guard indexed[canonicalId] == nil else { continue }

            guard let item = Self.findDictionaryItem(
                for: pattern,
                in: dictionaryItems
            ) else {
                continue
            }

            indexed[canonicalId] = Self.makeEntry(from: item)
        }

        self.entriesByCanonicalId = indexed
        self.loadError = nil
    }

    private init(entriesByCanonicalId: [String: JargonDictionaryEntry], loadError: Error) {
        self.entriesByCanonicalId = entriesByCanonicalId
        self.loadError = loadError
    }

    func entry(forCanonicalId canonicalId: String) -> JargonDictionaryEntry? {
        entriesByCanonicalId[canonicalId]
    }

    private static func loadDictionaryItems(bundle: Bundle) throws -> [DictionaryItemDTO] {
        guard let url = bundle.url(forResource: "dict_json", withExtension: "json") else {
            throw JargonDictionaryStoreError.missingResource("dict_json.json")
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JargonDictionaryStoreError.decodingFailed(error.localizedDescription)
        }

        do {
            return try JSONDecoder().decode([DictionaryItemDTO].self, from: data)
        } catch {
            throw JargonDictionaryStoreError.decodingFailed(error.localizedDescription)
        }
    }

    private static func loadMatcherPatterns(bundle: Bundle) throws -> [ExactPatternRecord] {
        guard let url = bundle.url(forResource: "exact_matcher", withExtension: "json") else {
            throw JargonDictionaryStoreError.missingResource("exact_matcher.json")
        }

        let data = try Data(contentsOf: url)
        let artifact = try JSONDecoder().decode(ExactMatcherArtifact.self, from: data)
        return artifact.patterns
    }

    private static func findDictionaryItem(
        for pattern: ExactPatternRecord,
        in items: [DictionaryItemDTO]
    ) -> DictionaryItemDTO? {
        let canonicalId = pattern.canonicalId
        let canonicalTermKey = normalizeCanonicalKey(pattern.canonicalTerm)

        return items.first { item in
            let termKey = normalizeCanonicalKey(item.term)

            if termKey == canonicalId {
                return true
            }

            if termKey == canonicalTermKey {
                return true
            }

            return item.term.caseInsensitiveCompare(pattern.canonicalTerm) == .orderedSame
        }
    }

    private static func makeEntry(from item: DictionaryItemDTO) -> JargonDictionaryEntry {
        JargonDictionaryEntry(
            definition: item.definition.trimmingCharacters(in: .whitespacesAndNewlines),
            indirectExample: item.definition2.trimmingCharacters(in: .whitespacesAndNewlines),
            translatedExample: item.example.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    private static func normalizeCanonicalKey(_ text: String) -> String {
        let normalized = text
            .precomposedStringWithCanonicalMapping
            .lowercased()

        let scalars = normalized.unicodeScalars.map { scalar -> String in
            CharacterSet.alphanumerics.contains(scalar) ? String(scalar) : " "
        }

        return scalars
            .joined()
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
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
