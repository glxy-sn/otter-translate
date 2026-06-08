//
//  SearchBar.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//


import SwiftUI

struct SearchBar: View {
    
    @Environment(\.layout) var layout
    
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    let placeholder: String
    
    // MARK: - Init
    init(
        text: Binding<String>,
        placeholder: String = "Search corporate terms"
    ) {
        self._text       = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        HStack(spacing: layout.spacingSmall) {
            
            HStack(spacing: layout.spacingSmall) {
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: layout.fontBody))
                    .foregroundStyle(Color.primaryBlue.opacity(0.5))
                
                TextField(placeholder, text: $text)
                    .font(.system(size: layout.fontBody))
                    .foregroundStyle(Color.primaryBlue)
                    .tint(Color.primaryBlue)
                    .focused($isFocused)
                    .submitLabel(.search)
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: layout.fontBody))
                            .foregroundStyle(Color.primaryBlue.opacity(0.4))
                    }
                    .transition(.opacity.animation(.easeInOut(duration: 0.15)))
                }
            }
            .padding(.horizontal, layout.cardPadding)
            .padding(.vertical, layout.spacingSmall)
            .background(Color.primaryBlue.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
            
            if isFocused {
                Button("Cancel") {
                    text      = ""
                    isFocused = false
                }
                .font(.system(size: layout.fontSmall, weight: .medium))
                .foregroundStyle(Color.primaryBlue)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: Constants.Animation.defaultDuration), value: isFocused)
        .animation(.easeInOut(duration: Constants.Animation.defaultDuration), value: text.isEmpty)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        SearchBar(text: .constant(""))
        SearchBar(text: .constant("bandwidth"))
    }
    .padding()
    .background(Color.backgroundCream)
    .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
