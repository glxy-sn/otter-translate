//
//  JargonCard.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import SwiftUI

struct JargonCard: View {
    
    @Environment(\.layout) var layout
    
    let entry: JargonEntry
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .center) {
            
            // MARK: Text Content
            VStack(alignment: .leading, spacing: layout.spacingXS * 0.5) {
                
                // Term
                Text(entry.term)
                    .font(.system(size: layout.fontBody, weight: .semibold))
                    .foregroundStyle(Color.primaryBlue)
                    .lineLimit(1)
                
                // Definition
                Text(entry.definition)
                    .font(.system(size: layout.fontSmall))
                    .foregroundStyle(Color.primaryBlue.opacity(0.6))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: layout.fontSmall, weight: .medium))
                .foregroundStyle(Color.primaryBlue.opacity(0.3))
        }
        .padding(.horizontal, layout.cardPadding)
        .padding(.vertical, layout.spacingSmall)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: layout.cornerRadius)
                .stroke(Color.primaryBlue.opacity(0.1), lineWidth: 0.5)
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 8) {
        JargonCard(entry: JargonEntry.mockList[0])
        JargonCard(entry: JargonEntry.mockList[1])
        JargonCard(entry: JargonEntry.mockList[2])
    }
    .padding()
    .background(Color.backgroundCream)
    .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
