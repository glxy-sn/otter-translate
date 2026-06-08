//
//  TranslationBox.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//


import SwiftUI

struct CorpKeyTranslationBox: View {
    
    @Environment(\.layout) var layout
    
    let translatedText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: layout.spacingSmall) {
            
            HStack(spacing: layout.spacingSmall) {
                
                Image("otterKeyboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: layout.iconSize * 1.5, height: layout.iconSize * 1.5)
                
                Text("Otter Translation")
                    .font(.system(size: layout.fontSmall, weight: .semibold))
                    .foregroundStyle(Color.primaryBlue)
            }
            
            Text(translatedText)
                .font(.system(size: layout.fontBody))
                .foregroundStyle(Color.primaryBlue.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
        .padding(layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundCream)
        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadiusLarge))
        .overlay(
            RoundedRectangle(cornerRadius: layout.cornerRadiusLarge)
                .stroke(Color.primaryBlue.opacity(0.15), lineWidth: 0.5)
        )
    }
}

#Preview {
    VStack {
        CorpKeyTranslationBox(
            translatedText: "\"Let's use what we already have so we don't have to spend more.\""
        )
        
        CorpKeyTranslationBox(
            translatedText: "\"I'm afraid I don't have the bandwidth for this right now. Could we circle back at a later time?\""
        )
    }
    .padding()
    .background(Color.primaryBlue) // ← ganti preview bg jadi biru
    .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
