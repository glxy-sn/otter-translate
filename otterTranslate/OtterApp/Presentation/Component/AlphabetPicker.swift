//
//  AlphabetPicker.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 08/06/26.
//

import SwiftUI
import UIKit

struct AlphabetPickerView: View {
    
    @Environment(\.layout) var layout
    
    let alphabet: [String]
    let selectedLetter: String
    let onSelect: (String) -> Void
    
    @State private var lastSelectedLetter: String?
    
    var body: some View {
        GeometryReader { geo in
            let itemHeight = min(17, geo.size.height / CGFloat(alphabet.count))
            let pickerHeight = itemHeight * CGFloat(alphabet.count)
            
            VStack(spacing: 0) {
                ForEach(alphabet, id: \.self) { letter in
                    Text(letter)
                        .font(.system(
                            size: fontSize(
                                itemHeight: itemHeight,
                                isSelected: selectedLetter == letter
                            ),
                            weight: selectedLetter == letter ? .bold : .semibold
                        ))
                        .foregroundStyle(selectedLetter == letter ? .white : Color.primaryBlue)
                        .frame(width: 32, height: itemHeight)
                        .background {
                            if selectedLetter == letter {
                                Circle()
                                    .fill(Color.primaryBlue)
                                    .frame(
                                        width: min(30, itemHeight + 10),
                                        height: min(30, itemHeight + 10)
                                    )
                            }
                        }
                }
            }
            .frame(width: 56, height: pickerHeight, alignment: .topTrailing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let index = indexForLocation(
                            y: value.location.y,
                            itemHeight: itemHeight
                        )
                        
                        guard alphabet.indices.contains(index) else { return }
                        
                        let letter = alphabet[index]
                        
                        guard letter != lastSelectedLetter else { return }
                        
                        lastSelectedLetter = letter
                        select(letter)
                    }
                    .onEnded { _ in
                        lastSelectedLetter = nil
                    }
            )
        }
        .frame(width: 56)
    }
    
    private func fontSize(itemHeight: CGFloat, isSelected: Bool) -> CGFloat {
        if isSelected {
            return min(layout.fontXS + 2, itemHeight * 0.85)
        } else {
            return min(layout.fontXS, itemHeight * 0.72)
        }
    }
    
    private func indexForLocation(y: CGFloat, itemHeight: CGFloat) -> Int {
        let rawIndex = Int((y / itemHeight).rounded(.down))
        return min(max(rawIndex, 0), alphabet.count - 1)
    }
    
    private func select(_ letter: String) {
        UISelectionFeedbackGenerator().selectionChanged()
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
            onSelect(letter)
        }
    }
}

// MARK: - Preview
#Preview {
    AlphabetPickerView(
        alphabet: ["#"] + Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) },
        selectedLetter: "L"
    ) { _ in }
    .frame(height: 520)
    .padding()
    .background(Color.backgroundCream)
    .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
