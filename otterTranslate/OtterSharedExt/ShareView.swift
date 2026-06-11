//
//  ShareView.swift
//  OtterSharedExt
//

import SwiftUI

struct ShareView: View {
    @ObservedObject var viewModel: ShareViewModel

    let onDone: () -> Void
    let onCancel: () -> Void

    var body: some View {
        GeometryReader { geo in
            let layout = ExtLayout(width: geo.size.width, height: geo.size.height)
            ZStack {
                Color.primaryBlueExt.ignoresSafeArea()

                if let shareEntry = viewModel.entry,
                   let detectedTerm = shareEntry.primaryMatch {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(detectedTerm.canonicalTerm.lowercased())
                                .font(.system(
                                    size: layout.fontHero,
                                    weight: .bold,
                                    design: .serif
                                ))
                                .foregroundStyle(.white)
                                .padding(.horizontal, layout.horizontalPadding)
                                .padding(.top, layout.spacingXXL)
                                .padding(.bottom, layout.spacingLarge)

                            divider(layout: layout)
                                .padding(.bottom, layout.spacingLarge)

                            section(
                                title: "Meaning",
                                content: shareEntry.dictionaryEntry?.definition
                                    ?? "Definition not available for this term.",
                                layout: layout
                            )
                            .padding(.bottom, layout.spacingLarge)

                            divider(layout: layout)
                                .padding(.bottom, layout.spacingLarge)

                            section(
                                title: "Indirect Example",
                                content: shareEntry.dictionaryEntry?.indirectExample
                                    ?? "\"\(detectedTerm.matchedText)\"",
                                layout: layout
                            )
                            .padding(.bottom, layout.spacingLarge)

                            corpKeyTranslationBox(
                                translatedText: shareEntry.dictionaryEntry?.translatedExample
                                    ?? "Translation example not available for this term.",
                                layout: layout
                            )
                            .padding(.horizontal, layout.horizontalPadding)
                            .padding(.bottom, layout.spacingXXL)
                        }
                    }
                } else if viewModel.entry != nil {
                    ContentUnavailableView(
                        "No jargon found",
                        systemImage: "text.magnifyingglass",
                        description: Text("Teks ditemukan, tapi tidak ada jargon yang cocok di kalimat ini.")
                    )
                    .foregroundStyle(.white)
                } else {
                    ContentUnavailableView(
                        "No text found",
                        systemImage: "text.quote",
                        description: Text("Pilih teks message lalu share kembali ke OtterTranslate.")
                    )
                    .foregroundStyle(.white)
                }
            }
        }
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
        .presentationBackground(Color.primaryBlueExt)
    }

    private func divider(layout: ExtLayout) -> some View {
        Rectangle()
            .fill(.white.opacity(0.2))
            .frame(height: 0.5)
            .padding(.horizontal, layout.horizontalPadding)
    }

    private func section(title: String, content: String, layout: ExtLayout) -> some View {
        VStack(alignment: .leading, spacing: layout.spacingSmall) {
            Text(title)
                .font(.system(size: layout.fontXS, weight: .semibold))
                .foregroundStyle(.white.opacity(0.6))

            Text(content)
                .font(.system(size: layout.fontTitle, weight: .semibold))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, layout.horizontalPadding)
    }

    private func corpKeyTranslationBox(translatedText: String, layout: ExtLayout) -> some View {
        VStack(alignment: .leading, spacing: layout.spacingSmall) {
            HStack(spacing: layout.spacingSmall) {
                Image("otterKeyboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: layout.iconSize * 1.5, height: layout.iconSize * 1.5)

                Text("Otter Translation")
                    .font(.system(size: layout.fontSmall, weight: .semibold))
                    .foregroundStyle(Color.primaryBlueExt)
            }

            Text(translatedText)
                .font(.system(size: layout.fontBody))
                .foregroundStyle(Color.primaryBlueExt.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
        .padding(layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundCreamExt)
        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadiusLarge))
        .overlay(
            RoundedRectangle(cornerRadius: layout.cornerRadiusLarge)
                .stroke(Color.primaryBlueExt.opacity(0.15), lineWidth: 0.5)
        )
    }
}

private struct ExtLayout {
    let width: CGFloat
    let height: CGFloat

    private var safeWidth: CGFloat { max(width, 1) }

    var horizontalPadding: CGFloat { safeWidth * 0.05 }
    var cardPadding: CGFloat { safeWidth * 0.04 }
    var cornerRadiusLarge: CGFloat { safeWidth * 0.04 }
    var iconSize: CGFloat { safeWidth * 0.06 }

    var fontXS: CGFloat { safeWidth * 0.028 }
    var fontSmall: CGFloat { safeWidth * 0.033 }
    var fontBody: CGFloat { safeWidth * 0.038 }
    var fontTitle: CGFloat { safeWidth * 0.055 }
    var fontHero: CGFloat { safeWidth * 0.11 }

    var spacingSmall: CGFloat { safeWidth * 0.03 }
    var spacingLarge: CGFloat { safeWidth * 0.06 }
    var spacingXXL: CGFloat { safeWidth * 0.12 }
}

private extension Color {
    static let primaryBlueExt = Color(red: 0.10, green: 0.24, blue: 0.63)
    static let backgroundCreamExt = Color(red: 0.99, green: 0.97, blue: 0.92)
}

#Preview {
    let viewModel = ShareViewModel()
    viewModel.setInputText("Let's do a deep dive on our roadmap.")
    return ShareView(viewModel: viewModel, onDone: {}, onCancel: {})
}
