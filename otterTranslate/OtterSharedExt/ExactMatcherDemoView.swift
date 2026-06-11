//
//  ExactMatcherDemoView.swift
//  OtterSharedExt
//

import SwiftUI

struct ExactMatcherDemoView: View {
    @State private var inputText = "Let's do a deep dive on our 30,000-foot view strategy."
    @State private var matches: [ExactMatchResult] = []

    private let matcher = ExactJargonMatcher.shared

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Type or paste a sentence to detect jargon offline.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextEditor(text: $inputText)
                    .frame(minHeight: 120)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.25))
                    }
                    .onChange(of: inputText) { _, newValue in
                        runDetection(on: newValue)
                    }

                if let loadError = matcher.loadError {
                    Label(loadError.localizedDescription, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.orange)
                }

                if matches.isEmpty {
                    ContentUnavailableView(
                        "No jargon found",
                        systemImage: "text.magnifyingglass",
                        description: Text("Try phrases like \"deep dive\" or \"circle back\".")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(matches) { match in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(match.canonicalTerm)
                                .font(.headline)

                            Text("Matched: \"\(match.matchedText)\"")
                                .font(.subheadline)

                            Text("ID: \(match.canonicalId)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .navigationTitle("Exact Matcher Demo")
            .onAppear {
                runDetection(on: inputText)
            }
        }
    }

    private func runDetection(on text: String) {
        matches = matcher.detectExactTermsWithDetails(in: text)
    }
}

#Preview {
    ExactMatcherDemoView()
}
