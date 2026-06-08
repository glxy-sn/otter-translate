//
//  Picker.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

// AlphaPicker.swift
// OtterApp

import SwiftUI

struct AlphaPicker: View {
    
    @Environment(\.layout) var layout
    
    @Binding var selectedLetter: String
    let availableLetters: Set<String>
    
    private let sections = Constants.Alphabet.letters
    
    // MARK: - Init
    init(
        selectedLetter: Binding<String>,
        availableLetters: Set<String> = Set(Constants.Alphabet.letters)
    ) {
        self._selectedLetter  = selectedLetter
        self.availableLetters = availableLetters
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 1) {
            ForEach(sections, id: \.self) { letter in
                
                let isAvailable = availableLetters.contains(letter)
                let isSelected  = selectedLetter == letter
                
                Button {
                    guard isAvailable else { return }
                    selectedLetter = letter
                    triggerHaptic()
                } label: {
                    ZStack {
                        Circle()
                            .fill(isSelected ? Color.primaryBlue : Color.clear)
                            .frame(width: 18, height: 18)
                        
                        Text(letter)
                            .font(.system(
                                size: 10,
                                weight: isSelected ? .bold : .regular
                            ))
                            .foregroundStyle(
                                isSelected
                                ? .white
                                : isAvailable
                                    ? Color.primaryBlue.opacity(0.6)
                                    : Color.primaryBlue.opacity(0.2)
                            )
                    }
                    .frame(width: 18, height: 18)
                }
                .disabled(!isAvailable)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 2)
    }
    
    // MARK: - Haptic
    private func triggerHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Preview
#Preview {
    HStack {
        Spacer()
        AlphaPicker(
            selectedLetter: .constant("B"),
            availableLetters: Set(["#", "A", "B", "C", "D", "E", "L", "P", "S"])
        )
        .padding(.trailing, 4)
    }
    .frame(height: 600)
    .background(Color.backgroundCream)
    .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
