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
            let layout = LayoutConstants(width: geo.size.width, height: geo.size.height)
            ZStack {
                Color.primaryBlueExt.ignoresSafeArea()

                if let shareEntry = viewModel.entry, shareEntry.termDetails.isEmpty == false {
                    VStack(spacing: 0) {
                        if shareEntry.termDetails.count > 1 {
                            termPageIndicator(
                                currentIndex: viewModel.selectedTermIndex,
                                totalCount: shareEntry.termDetails.count,
                                layout: layout
                            )
                            .padding(.top, layout.spacingLarge)
                            .padding(.bottom, layout.spacingSmall)
                        }

                        TabView(selection: $viewModel.selectedTermIndex) {
                            ForEach(
                                Array(shareEntry.termDetails.enumerated()),
                                id: \.element.id
                            ) { index, detail in
                                termDetailPage(detail: detail, layout: layout)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
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

    private func termPageIndicator(
        currentIndex: Int,
        totalCount: Int,
        layout: LayoutConstants
    ) -> some View {
        VStack(spacing: layout.spacingSmall) {
            Text("\(currentIndex + 1) of \(totalCount)")
                .font(.system(size: layout.fontXS, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))

            HStack(spacing: layout.spacingSmall * 0.5) {
                ForEach(0..<totalCount, id: \.self) { index in
                    Capsule()
                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.35))
                        .frame(width: index == currentIndex ? 18 : 6, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func termDetailPage(detail: ShareTermDetail, layout: LayoutConstants) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text(detail.match.canonicalTerm.lowercased())
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
                    content: detail.dictionaryEntry?.definition
                        ?? "Definition not available for this term.",
                    layout: layout
                )
                .padding(.bottom, layout.spacingLarge)

                divider(layout: layout)
                    .padding(.bottom, layout.spacingLarge)

                section(
                    title: "Indirect Example",
                    content: detail.dictionaryEntry?.indirectExample
                        ?? "\"\(detail.match.matchedText)\"",
                    layout: layout
                )
                .padding(.bottom, layout.spacingLarge)

                corpKeyTranslationBox(
                    translatedText: detail.dictionaryEntry?.translatedExample
                        ?? "Translation example not available for this term.",
                    layout: layout
                )
                .padding(.horizontal, layout.horizontalPadding)
                .padding(.bottom, layout.spacingXXL)
            }
        }
    }

    private func divider(layout: LayoutConstants) -> some View {
        Rectangle()
            .fill(.white.opacity(0.2))
            .frame(height: 0.5)
            .padding(.horizontal, layout.horizontalPadding)
    }

    private func section(title: String, content: String, layout: LayoutConstants) -> some View {
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

    private func corpKeyTranslationBox(translatedText: String, layout: LayoutConstants) -> some View {
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

#Preview("Single term") {
    let viewModel = ShareViewModel()
    viewModel.setInputText("Let's do a deep dive on our roadmap.")
    return ShareView(viewModel: viewModel, onDone: {}, onCancel: {})
}

#Preview("Multiple terms") {
    let viewModel = ShareViewModel()
    viewModel.setInputText(
        "Let's do a deep dive and circle back on our 30,000-foot view strategy."
    )
    return ShareView(viewModel: viewModel, onDone: {}, onCancel: {})
}
