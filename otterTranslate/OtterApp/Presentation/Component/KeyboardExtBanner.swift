//
//  KeyboardExtBanner.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import SwiftUI

struct KeyboardExtensionBanner: View {
    
    @Environment(\.layout) var layout
    
    let onSetup: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .center, spacing: layout.spacingSmall) {
            
            // Icon
            Image("otterKeyboard")
                .resizable()
                .scaledToFit()
                .frame(width: layout.iconSize * 1.8, height: layout.iconSize * 1.8)
            
            // Text
            VStack(alignment: .leading, spacing: layout.spacingXS * 0.3) {
                Text("Keyboard Extension available")
                    .font(.system(size: layout.fontSmall, weight: .semibold))
                    .foregroundStyle(Color.primaryBlue)
                    .fixedSize(horizontal: true, vertical: false)
                
                Text("Translate jargon anywhere.")
                    .font(.system(size: layout.fontXS))
                    .foregroundStyle(Color.primaryBlue.opacity(0.6))
                    .fixedSize(horizontal: true, vertical: false)
            }
            
            Spacer(minLength: layout.spacingSmall)
            
            // Set up Button
            Button {
                onSetup()
            } label: {
                Text("Set up")
                    .font(.system(size: layout.fontSmall, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: layout.iconSize * 2.5, height: layout.iconSize * 1.2)
                    .background(Color.primaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius * 1.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, layout.cardPadding)
        .padding(.vertical, layout.spacingSmall)
        .background(Color.primaryBlue.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: layout.cornerRadius)
                .stroke(Color.primaryBlue.opacity(0.15), lineWidth: 0.5)
        )
    }
}

// MARK: - Preview
#Preview {
    VStack {
        KeyboardExtensionBanner {
            print("setup tapped")
        }
    }
    .padding()
    .background(Color.backgroundCream)
    .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
