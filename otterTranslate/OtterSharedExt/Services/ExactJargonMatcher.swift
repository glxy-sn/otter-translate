//
//  ExactJargonMatcher.swift
//  OtterSharedExt
//

import Foundation

// MARK: - Codable Models

struct MatcherMetadata: Codable, Equatable {
    let matcherType: String
    let boundaryRule: String
    let sortOrder: String
    let normalization: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case matcherType = "matcher_type"
        case boundaryRule = "boundary_rule"
        case sortOrder = "sort_order"
        case normalization
        case createdAt = "created_at"
    }
}

struct ExactPatternRecord: Codable, Equatable {
    let term: String
    let canonicalId: String
    let canonicalTerm: String
    let pattern: String
    let patternFlags: String
    let matchLength: Int

    enum CodingKeys: String, CodingKey {
        case term
        case canonicalId = "canonical_id"
        case canonicalTerm = "canonical_term"
        case pattern
        case patternFlags = "pattern_flags"
        case matchLength = "match_length"
    }
}

struct ExactMatcherArtifact: Codable, Equatable {
    let metadata: MatcherMetadata
    let patterns: [ExactPatternRecord]
}

struct CompiledExactPatternRecord: Equatable {
    let term: String
    let canonicalId: String
    let canonicalTerm: String
    let pattern: String
    let patternFlags: String
    let matchLength: Int
    let regex: NSRegularExpression

    init?(record: ExactPatternRecord) {
        let flags: NSRegularExpression.Options =
            record.patternFlags == "IGNORECASE" ? .caseInsensitive : []

        guard let regex = try? NSRegularExpression(
            pattern: record.pattern,
            options: flags
        ) else {
            NSLog(
                "ExactJargonMatcher: skipping invalid regex for term '%@'",
                record.term
            )
            return nil
        }

        self.term = record.term
        self.canonicalId = record.canonicalId
        self.canonicalTerm = record.canonicalTerm
        self.pattern = record.pattern
        self.patternFlags = record.patternFlags
        self.matchLength = record.matchLength
        self.regex = regex
    }
}

struct ExactMatchResult: Equatable, Identifiable {
    let canonicalId: String
    let canonicalTerm: String
    let matchedText: String
    let start: Int
    let end: Int

    var id: String { "\(canonicalId)-\(start)-\(end)" }
}

// MARK: - Errors

enum ExactJargonMatcherError: LocalizedError, Equatable {
    case missingResource(String)
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            return "Could not find \(name) in the app bundle."
        case .decodingFailed(let message):
            return "Failed to decode exact matcher JSON: \(message)"
        }
    }
}

// MARK: - Matcher

/// Offline exact jargon matcher backed by `exact_matcher.json`.
///
/// Compatibility note: patterns use fixed-width lookbehind/lookahead such as
/// `(?<![A-Za-z0-9])` and `(?![A-Za-z0-9])`. `NSRegularExpression` (ICU) supports
/// these fixed-width assertions on iOS. Variable-width lookbehind is not supported.
final class ExactJargonMatcher {
    static let shared: ExactJargonMatcher = {
        do {
            return try ExactJargonMatcher()
        } catch {
            NSLog("ExactJargonMatcher.shared failed to load: \(error.localizedDescription)")
            return ExactJargonMatcher.empty(loadError: error)
        }
    }()

    private(set) var metadata: MatcherMetadata?
    private(set) var loadError: Error?
    private let compiledPatterns: [CompiledExactPatternRecord]

    init(
        resourceName: String = "exact_matcher",
        bundle: Bundle = .main
    ) throws {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw ExactJargonMatcherError.missingResource("\(resourceName).json")
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ExactJargonMatcherError.decodingFailed(error.localizedDescription)
        }

        let artifact: ExactMatcherArtifact
        do {
            artifact = try JSONDecoder().decode(ExactMatcherArtifact.self, from: data)
        } catch {
            throw ExactJargonMatcherError.decodingFailed(error.localizedDescription)
        }

        metadata = artifact.metadata
        loadError = nil

        let sortedPatterns = artifact.patterns.sorted { lhs, rhs in
            if lhs.matchLength != rhs.matchLength {
                return lhs.matchLength > rhs.matchLength
            }
            return lhs.term.localizedCaseInsensitiveCompare(rhs.term) == .orderedAscending
        }

        compiledPatterns = sortedPatterns.compactMap(CompiledExactPatternRecord.init(record:))
    }

    private init(
        metadata: MatcherMetadata?,
        compiledPatterns: [CompiledExactPatternRecord],
        loadError: Error?
    ) {
        self.metadata = metadata
        self.compiledPatterns = compiledPatterns
        self.loadError = loadError
    }

    private static func empty(loadError: Error) -> ExactJargonMatcher {
        ExactJargonMatcher(metadata: nil, compiledPatterns: [], loadError: loadError)
    }

    /// Returns unique `canonical_id` values in longest-match-first discovery order.
    func detectExactTerms(in text: String) -> [String] {
        var found: [String] = []

        for result in detectExactTermsWithDetails(in: text) where !found.contains(result.canonicalId) {
            found.append(result.canonicalId)
        }

        return found
    }

    /// Returns non-overlapping matches, preserving longest-match-first behavior.
    func detectExactTermsWithDetails(in text: String) -> [ExactMatchResult] {
        guard text.isEmpty == false else { return [] }

        var results: [ExactMatchResult] = []
        var occupiedSpans: [(start: Int, end: Int)] = []
        let fullRange = NSRange(text.startIndex..., in: text)

        for record in compiledPatterns {
            let matches = record.regex.matches(in: text, options: [], range: fullRange)

            for match in matches {
                let start = match.range.location
                let end = start + match.range.length

                let overlaps = occupiedSpans.contains { occupied in
                    start < occupied.end && end > occupied.start
                }

                if overlaps {
                    continue
                }

                guard let swiftRange = Range(match.range, in: text) else {
                    continue
                }

                results.append(
                    ExactMatchResult(
                        canonicalId: record.canonicalId,
                        canonicalTerm: record.canonicalTerm,
                        matchedText: String(text[swiftRange]),
                        start: start,
                        end: end
                    )
                )
                occupiedSpans.append((start: start, end: end))
            }
        }

        return results
    }
}
