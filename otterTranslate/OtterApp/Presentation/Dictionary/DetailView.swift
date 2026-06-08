//
//  DetailView.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 07/06/26.
//


import SwiftUI

struct DictionaryDetailView: View {
    
    @Environment(\.layout) var layout
    @Environment(\.dismiss) var dismiss
    
    let entry: JargonEntry
    
    var body: some View {
        ZStack {
            Color.primaryBlue.ignoresSafeArea()
    
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: Term
                    Text(entry.term.lowercased())
                        .font(.system(
                            size: layout.fontHero,
                            weight: .bold,
                            design: .serif
                        ))
                        .foregroundStyle(.white)
                        .padding(.horizontal, layout.horizontalPadding)
                        .padding(.top, layout.spacingXXL)
                        .padding(.bottom, layout.spacingLarge)
                    
                    // MARK: Divider
                    divider
                        .padding(.bottom, layout.spacingLarge)
                    
                    // MARK: Meaning
                    VStack(alignment: .leading, spacing: layout.spacingSmall) {
                        Text("Meaning")
                            .font(.system(size: layout.fontXS, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                        
                        Text(entry.definition)
                            .font(.system(size: layout.fontTitle, weight: .semibold))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, layout.horizontalPadding)
                    .padding(.bottom, layout.spacingLarge)
                    
                    // MARK: Divider
                    divider
                        .padding(.bottom, layout.spacingLarge)
                    
                    // MARK: Used in a sentence
                    VStack(alignment: .leading, spacing: layout.spacingSmall) {
                        Text("Used in a sentence")
                            .font(.system(size: layout.fontXS, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                        
                        Text("\"\(entry.cleanExample)\"")
                            .font(.system(size: layout.fontTitle, weight: .semibold))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, layout.horizontalPadding)
                    .padding(.bottom, layout.spacingLarge)
                    
                    // MARK: CorpKey Translation Box
                    CorpKeyTranslationBox(
                        translatedText: "Let's use what we already have so we don't have to spend more."
                    )
                    .padding(.horizontal, layout.horizontalPadding)
                    .padding(.bottom, layout.spacingXXL)
                }
            }
        }
        // Sheet handle indicator warna putih
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(layout.cornerRadiusLarge * 2.5)
        .presentationBackground(Color.primaryBlue)
    }
    
    // MARK: - Divider
    private var divider: some View {
        Rectangle()
            .fill(.white.opacity(0.2))
            .frame(height: 0.5)
            .padding(.horizontal, layout.horizontalPadding)
    }
}

// MARK: - Preview
#Preview {
    Color.backgroundCream
        .sheet(isPresented: .constant(true)) {
            GeometryReader { geo in
                DictionaryDetailView(entry: JargonEntry.mock)
                    .environment(\.layout, LayoutConstants(
                        width: geo.size.width,
                        height: geo.size.height
                    ))
            }
        }
        .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
