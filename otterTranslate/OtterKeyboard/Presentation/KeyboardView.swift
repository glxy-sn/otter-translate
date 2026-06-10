////
////  KeyboardView.swift
////  otterTranslate
////
////  Created by Shafa Tiara on 05/06/26.
////
//
//
//import SwiftUI
//
//struct KeyboardView: View {
//    
//    @Environment(\.layout) var layout
//    @ObservedObject var viewModel: KeyboardViewModel
//    
//    @State private var cursorVisible: Bool = true
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            
//            // MARK: Translation Result Box
//            if let result = viewModel.translationResult {
//                translationBox(result: result)
//                    .transition(.move(edge: .top).combined(with: .opacity))
//            }
//            
//            // MARK: Draft Field
//            draftField
//            
//            // MARK: QWERTY Rows
//            keyboardRows
//            
//            // MARK: Bottom Row
//            bottomRow
//        }
//        .background(Color(.systemGroupedBackground))
//        .animation(.easeInOut(duration: 0.2), value: viewModel.translationResult)
//        .onAppear {
//            startCursorBlink()
//        }
//    }
//    
//    // MARK: - Cursor Blink
//    private func startCursorBlink() {
//        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
//            cursorVisible.toggle()
//        }
//    }
//    
//    // MARK: - Translation Result Box
//    private func translationBox(result: String) -> some View {
//        HStack(alignment: .top, spacing: layout.spacingSmall) {
//            
//            VStack(alignment: .leading, spacing: layout.spacingXS) {
//                // Header
//                HStack(spacing: layout.spacingXS) {
//                    Image("otterKeyboard")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: layout.iconSize)
//                    
//                    Text("OtterSpeak")
//                        .font(.system(size: layout.fontSmall, weight: .semibold))
//                        .foregroundStyle(Color.primaryBlue)
//                }
//                
//                // Result text
//                Text(result)
//                    .font(.system(size: layout.fontBody))
//                    .foregroundStyle(Color.primary)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            
//            Spacer()
//            
//            // Use button
//            Button {
//                viewModel.useTranslation()
//            } label: {
//                HStack(spacing: layout.spacingXS) {
//                    Text("Use")
//                        .font(.system(size: layout.fontBody, weight: .semibold))
//                    Image(systemName: "arrow.right")
//                        .font(.system(size: layout.fontSmall, weight: .semibold))
//                }
//                .foregroundStyle(.white)
//                .padding(.horizontal, layout.spacingMedium)
//                .padding(.vertical, layout.spacingSmall)
//                .background(Color.primaryBlue)
//                .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius * 2))
//            }
//        }
//        .padding(layout.spacingMedium)
//        .background(Color(.systemBackground))
//        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
//        .overlay(
//            RoundedRectangle(cornerRadius: layout.cornerRadius)
//                .stroke(Color(.systemGray5), lineWidth: 1)
//        )
//        .padding(.horizontal, layout.spacingSmall)
//        .padding(.top, layout.spacingSmall)
//    }
//    
//    // MARK: - Draft Field
//    private var draftField: some View {
//        VStack(alignment: .leading, spacing: layout.spacingXS * 0.5) {
//            
//            // Label
//            HStack(spacing: layout.spacingXS * 0.5) {
//                Image(systemName: "pencil")
//                    .font(.system(size: layout.fontXS, weight: .semibold))
//                    .foregroundStyle(Color.primaryBlue)
//                
//                Text("YOUR DRAFT")
//                    .font(.system(size: layout.fontXS, weight: .bold))
//                    .foregroundStyle(Color.primaryBlue)
//                    .tracking(1.5)
//            }
//            
//            // Draft text + cursor
//            HStack(alignment: .bottom, spacing: 0) {
//                Text(viewModel.draftText.isEmpty ? "Type something..." : viewModel.draftText)
//                    .font(.system(size: layout.fontBody))
//                    .foregroundStyle(
//                        viewModel.draftText.isEmpty
//                        ? Color(.systemGray3)
//                        : Color.primary
//                    )
//                    .lineLimit(2)
//                
//                // Blinking cursor — only show when not placeholder
//                if !viewModel.draftText.isEmpty {
//                    Rectangle()
//                        .frame(width: 2, height: layout.fontBody)
//                        .foregroundStyle(Color.primaryBlue)
//                        .opacity(cursorVisible ? 1 : 0)
//                        .padding(.leading, 1)
//                        .padding(.bottom, 1)
//                }
//                
//                Spacer()
//            }
//            .frame(height: 40)
//        }
//        .padding(layout.spacingMedium)
//        .background(Color(.systemBackground))
//        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
//        .overlay(
//            RoundedRectangle(cornerRadius: layout.cornerRadius)
//                .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 1)
//        )
//        .padding(.horizontal, layout.spacingSmall)
//        .padding(.vertical, layout.spacingSmall)
//    }
//    
//    // MARK: - Keyboard Rows
//    private var keyboardRows: some View {
//        VStack(spacing: 6) {
//            
//            // Row 1 — q w e r t y u i o p
//            keyRow(keys: ["q","w","e","r","t","y","u","i","o","p"])
//            
//            // Row 2 — a s d f g h j k l
//            keyRow(keys: ["a","s","d","f","g","h","j","k","l"])
//            
//            // Row 3 — shift + z x c v b n m + backspace
//            HStack(spacing: 6) {
//                // Shift
//                specialKey(icon: "shift", width: keyWidth * 1.5) {
//                    viewModel.toggleShift()
//                }
//                
//                keyRow(keys: ["z","x","c","v","b","n","m"])
//                
//                // Backspace
//                specialKey(icon: "delete.left", width: keyWidth * 1.5) {
//                    viewModel.deleteBackward()
//                }
//            }
//        }
//        .padding(.horizontal, 3)
//    }
//    
//    // MARK: - Bottom Row
//    private var bottomRow: some View {
//        HStack(spacing: 6) {
//            
//            // 123
//            specialTextKey(text: "123", width: keyWidth * 1.5) {
//                viewModel.switchToNumeric()
//            }
//            
//            // Globe
//            specialKey(icon: "globe", width: keyWidth * 1.2) {
//                viewModel.switchKeyboard()
//            }
//            
//            // Space
//            spaceKey
//            
//            // Translate
//            translateKey
//        }
//        .padding(.horizontal, 3)
//        .padding(.vertical, 6)
//    }
//    
//    // MARK: - Key Components
//    private var keyWidth: CGFloat {
//        (layout.width - 6) / 10
//    }
//    
//    private func keyRow(keys: [String]) -> some View {
//        HStack(spacing: 6) {
//            ForEach(keys, id: \.self) { key in
//                Button {
//                    viewModel.insertText(
//                        viewModel.isShifted ? key.uppercased() : key
//                    )
//                } label: {
//                    Text(viewModel.isShifted ? key.uppercased() : key)
//                        .font(.system(size: 17, weight: .regular))
//                        .foregroundStyle(Color.primary)
//                        .frame(width: keyWidth - 6, height: 42)
//                        .background(Color(.systemBackground))
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                        .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
//                }
//            }
//        }
//    }
//    
//    private func specialKey(icon: String, width: CGFloat, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            Image(systemName: icon)
//                .font(.system(size: 16, weight: .regular))
//                .foregroundStyle(Color.primary)
//                .frame(width: width - 6, height: 42)
//                .background(Color(.systemGray4))
//                .clipShape(RoundedRectangle(cornerRadius: 5))
//                .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
//        }
//    }
//    
//    private func specialTextKey(text: String, width: CGFloat, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            Text(text)
//                .font(.system(size: 16, weight: .regular))
//                .foregroundStyle(Color.primary)
//                .frame(width: width - 6, height: 42)
//                .background(Color(.systemGray4))
//                .clipShape(RoundedRectangle(cornerRadius: 5))
//                .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
//        }
//    }
//    
//    private var spaceKey: some View {
//        Button {
//            viewModel.insertText(" ")
//        } label: {
//            Text("space")
//                .font(.system(size: 16, weight: .regular))
//                .foregroundStyle(Color.primary)
//                .frame(maxWidth: .infinity, minHeight: 42)
//                .background(Color(.systemBackground))
//                .clipShape(RoundedRectangle(cornerRadius: 5))
//                .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
//        }
//    }
//    
//    private var translateKey: some View {
//        Button {
//            viewModel.translate()
//        } label: {
//            HStack(spacing: 4) {
//                Image(systemName: "sparkles")
//                    .font(.system(size: 14, weight: .semibold))
//                Text("translate")
//                    .font(.system(size: 14, weight: .semibold))
//            }
//            .foregroundStyle(.white)
//            .frame(width: keyWidth * 2.5, height: 42)
//            .background(Color.primaryBlue)
//            .clipShape(RoundedRectangle(cornerRadius: 5))
//            .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    GeometryReader { geo in
//        KeyboardView(viewModel: KeyboardViewModel())
//            .environment(\.layout, LayoutConstants(
//                width: geo.size.width,
//                height: geo.size.height
//            ))
//    }
//}

//
//  KeyboardView.swift
//  OtterKeyboard
//

//
//  KeyboardView.swift
//  OtterKeyboard
//

//
//  KeyboardView.swift
//  OtterKeyboard
//

import SwiftUI

struct KeyboardView: View {
    
    @Environment(\.layout) var layout
    @ObservedObject var viewModel: KeyboardViewModel
    
    private let keyHeight: CGFloat = 36
    private let keySpacing: CGFloat = 5
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                if viewModel.isOtterPanelOpen {
                    otterPanel
                }
                
                keyboardRows
                    .padding(.top, viewModel.isOtterPanelOpen ? 6 : 8)
                
                bottomRow
            }
            .padding(.top, viewModel.isOtterPanelOpen ? 10 : 12)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .clipped()
        .animation(.easeInOut(duration: 0.2), value: viewModel.isOtterPanelOpen)
        .animation(.easeInOut(duration: 0.2), value: viewModel.keyboardMode)
        .animation(.easeInOut(duration: 0.2), value: viewModel.translationResult)
    }
    
    // MARK: - Otter Panel
    
    private var otterPanel: some View {
        HStack(spacing: 6) {
            draftCard
                .frame(maxWidth: .infinity)
            
            translationCard
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .padding(.top, 0)
        .padding(.bottom, 6)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Draft Card
    
    private var draftCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack(spacing: 5) {
                Image(systemName: "pencil")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.primaryBlue)
                
                Text("DRAFT")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.primaryBlue)
                
                Spacer()
                
                Text("\(viewModel.draftText.count)/300")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color(.systemGray2))
            }
            
            ZStack(alignment: .topLeading) {
                if viewModel.draftText.isEmpty {
                    HStack(spacing: 1) {
                        Text("Type...")
                            .font(.system(size: 15))
                            .foregroundStyle(Color(.systemGray3))
                        
                        BlinkingCursor()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    DraftTextWithCursor(text: viewModel.draftText)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .frame(height: 78)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .stroke(Color.primaryBlue.opacity(0.35), lineWidth: 1)
        )
    }
    
    // MARK: - Translation Card
    
    private var translationCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack(spacing: 5) {
                Image(systemName: "sparkles")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.primaryBlue)
                
                Text("TRANSLATION")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.primaryBlue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                
                Spacer(minLength: 3)
                
                if viewModel.translationResult != nil {
                    Button {
                        viewModel.useTranslation()
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "return")
                                .font(.system(size: 10, weight: .bold))
                            
                            Text("Insert")
                                .font(.system(size: 11, weight: .semibold))
                                .lineLimit(1)
                        }
                        .foregroundStyle(Color.primaryBlue)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(Color.primaryBlue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            
            ZStack(alignment: .topLeading) {
                if viewModel.isTranslating {
                    HStack(spacing: 5) {
                        ProgressView()
                            .scaleEffect(0.65)
                        
                        Text("Translating...")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(.systemGray))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if let result = viewModel.translationResult {
                    ScrollView(.vertical, showsIndicators: true) {
                        Text(result)
                            .font(.system(size: 15))
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.trailing, 4)
                    }
                    
                } else {
                    Text("Tap Translate")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(.systemGray2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .frame(height: 78)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
    
    // MARK: - Keyboard Rows
    
    private var keyboardRows: some View {
        VStack(spacing: keySpacing) {
            switch viewModel.keyboardMode {
            case .letters:
                lettersKeyboard
                
            case .numbers:
                numbersKeyboard
                
            case .symbols:
                symbolsKeyboard
            }
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Letters Keyboard
    
    private var lettersKeyboard: some View {
        VStack(spacing: keySpacing) {
            keyRow(keys: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"])
            
            HStack(spacing: keySpacing) {
                Spacer()
                    .frame(width: keyWidth * 0.5)
                
                keyRow(keys: ["a", "s", "d", "f", "g", "h", "j", "k", "l"])
                
                Spacer()
                    .frame(width: keyWidth * 0.5)
            }
            
            HStack(spacing: keySpacing) {
                specialKey(icon: "shift", width: keyWidth * 1.35) {
                    viewModel.toggleShift()
                }
                
                keyRow(keys: ["z", "x", "c", "v", "b", "n", "m"])
                
                specialKey(icon: "delete.left", width: keyWidth * 1.35) {
                    viewModel.deleteBackward()
                }
            }
        }
    }
    
    // MARK: - Numbers Keyboard
    
    private var numbersKeyboard: some View {
        VStack(spacing: keySpacing) {
            keyRow(keys: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
            
            keyRow(keys: ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""])
            
            HStack(spacing: keySpacing) {
                specialTextKey(text: "#+=", width: keyWidth * 1.35) {
                    viewModel.switchToSymbols()
                }
                
                keyRow(keys: [".", ",", "?", "!", "'"])
                
                specialKey(icon: "delete.left", width: keyWidth * 1.35) {
                    viewModel.deleteBackward()
                }
            }
        }
    }
    
    // MARK: - Symbols Keyboard
    
    private var symbolsKeyboard: some View {
        VStack(spacing: keySpacing) {
            keyRow(keys: ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
            
            keyRow(keys: ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"])
            
            HStack(spacing: keySpacing) {
                specialTextKey(text: "123", width: keyWidth * 1.35) {
                    viewModel.switchToNumbers()
                }
                
                keyRow(keys: [".", ",", "?", "!", "'"])
                
                specialKey(icon: "delete.left", width: keyWidth * 1.35) {
                    viewModel.deleteBackward()
                }
            }
        }
    }
    
    // MARK: - Bottom Row
    
    private var bottomRow: some View {
        HStack(spacing: keySpacing) {
            modeSwitchKey
            otterKey
            spaceKey
            translateKey
        }
        .padding(.horizontal, 4)
        .padding(.top, 5)
        .padding(.bottom, 0)
    }
    
    private var modeSwitchKey: some View {
        Button {
            if viewModel.keyboardMode == .letters {
                viewModel.switchToNumbers()
            } else {
                viewModel.switchToLetters()
            }
        } label: {
            Text(viewModel.keyboardMode == .letters ? "123" : "ABC")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.primary)
                .frame(width: 52, height: keyHeight)
                .background(Color(.systemGray4))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 1)
        }
    }
    
    private var otterKey: some View {
        Button {
            viewModel.toggleOtterPanel()
        } label: {
            Image("otterKeyboard")
                .resizable()
                .scaledToFit()
                .frame(width: 23, height: 23)
                .frame(width: 44, height: keyHeight)
                .background(
                    viewModel.isOtterPanelOpen
                    ? Color.primaryBlue.opacity(0.14)
                    : Color(.systemGray4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(
                            viewModel.isOtterPanelOpen
                            ? Color.primaryBlue.opacity(0.45)
                            : Color.clear,
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 1)
        }
    }
    
    private var spaceKey: some View {
        Button {
            viewModel.insertText(" ")
        } label: {
            Text("space")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, minHeight: keyHeight)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 1)
        }
    }
    
    private var translateKey: some View {
        Button {
            viewModel.translate()
        } label: {
            HStack(spacing: 3) {
                if viewModel.isTranslating {
                    ProgressView()
                        .scaleEffect(0.6)
                        .tint(.white)
                } else {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11, weight: .semibold))
                }
                
                Text("Translate")
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
            }
            .foregroundStyle(.white)
            .frame(width: 88, height: keyHeight)
            .background(Color.primaryBlue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 1)
        }
        .disabled(viewModel.isTranslating)
    }
    
    // MARK: - Key Components
    
    private var keyWidth: CGFloat {
        let totalSpacing = 9 * keySpacing
        let horizontalPadding: CGFloat = 8
        return (layout.width - totalSpacing - horizontalPadding) / 10
    }
    
    private func keyRow(keys: [String]) -> some View {
        HStack(spacing: keySpacing) {
            ForEach(keys, id: \.self) { key in
                Button {
                    let output = shouldUppercase(key) ? key.uppercased() : key
                    viewModel.insertText(output)
                } label: {
                    Text(shouldUppercase(key) ? key.uppercased() : key)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(Color.primary)
                        .frame(width: keyWidth, height: keyHeight)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 1)
                }
            }
        }
    }
    
    private func specialKey(
        icon: String,
        width: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.primary)
                .frame(width: width, height: keyHeight)
                .background(
                    icon == "shift" && viewModel.isShifted
                    ? Color.primaryBlue.opacity(0.18)
                    : Color(.systemGray4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(
                            icon == "shift" && viewModel.isShifted
                            ? Color.primaryBlue.opacity(0.5)
                            : Color.clear,
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 1)
        }
    }
    
    private func specialTextKey(
        text: String,
        width: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.primary)
                .frame(width: width, height: keyHeight)
                .background(Color(.systemGray4))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 1)
        }
    }
    
    private func shouldUppercase(_ key: String) -> Bool {
        guard viewModel.keyboardMode == .letters else {
            return false
        }
        
        return viewModel.isShifted
    }
}

// MARK: - Draft Text With Cursor

private struct DraftTextWithCursor: View {
    
    let text: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                (
                    Text(text)
                        .foregroundStyle(Color.primary)
                    +
                    Text("▏")
                        .foregroundStyle(Color.primaryBlue)
                )
                .font(.system(size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .id("draftCursor")
            }
            .onChange(of: text) { _ in
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.12)) {
                        proxy.scrollTo("draftCursor", anchor: .bottom)
                    }
                }
            }
        }
    }
}

// MARK: - Blinking Cursor

private struct BlinkingCursor: View {
    
    @State private var isVisible = true
    
    var body: some View {
        Text("▏")
            .font(.system(size: 15))
            .foregroundStyle(Color.primaryBlue)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.55, repeats: true) { _ in
                    isVisible.toggle()
                }
            }
    }
}

// MARK: - Preview

#Preview {
    GeometryReader { geo in
        KeyboardView(viewModel: KeyboardViewModel())
            .environment(
                \.layout,
                 LayoutConstants(
                    width: geo.size.width,
                    height: geo.size.height
                 )
            )
    }
}
