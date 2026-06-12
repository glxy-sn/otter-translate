////
////  KeyboardViewModel.swift
////  otterTranslate
////
////  Created by Shafa Tiara on 05/06/26.
////
//
//import SwiftUI
//import Combine
//
//final class KeyboardViewModel: ObservableObject {
//    
//    // MARK: - Published
//    @Published var draftText: String = ""
//    @Published var translationResult: String? = nil
//    @Published var isShifted: Bool = false
//    @Published var isTranslating: Bool = false
//    
//    // Callbacks ke KeyboardViewController
//    var onInsertText: ((String) -> Void)?
//    var onDeleteBackward: (() -> Void)?
//    var onSwitchKeyboard: (() -> Void)?
//    
//    // MARK: - Actions
//    func insertText(_ text: String) {
//        draftText += text
//        if isShifted { isShifted = false }
//    }
//    
//    func deleteBackward() {
//        if !draftText.isEmpty {
//            draftText.removeLast()
//        }
//    }
//    
//    func toggleShift() {
//        isShifted.toggle()
//    }
//    
//    func switchToNumeric() {
//        // Nanti: switch ke numeric layout
//        print("switch to numeric")
//    }
//    
//    func switchKeyboard() {
//        onSwitchKeyboard?()
//    }
//    
//    func translate() {
//        guard !draftText.isEmpty else { return }
//        isTranslating = true
//        
//        // Nanti: call T5/BART model
//        // Untuk sekarang pakai placeholder
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            self?.translationResult = "Certainly, I'd be happy to set aside time. I'll send a calendar invite shortly."
//            self?.isTranslating = false
//        }
//    }
//    
//    func useTranslation() {
//        guard let result = translationResult else { return }
//        // Insert ke text field app yang aktif
//        onInsertText?(result)
//        // Clear draft dan result
//        draftText = ""
//        translationResult = nil
//    }
//}
//
//  KeyboardViewModel.swift
//  OtterKeyboard
//

import SwiftUI
import Combine

enum KeyboardMode {
    case letters
    case numbers
    case symbols
}

final class KeyboardViewModel: ObservableObject {
    
    // MARK: - Published
    
    @Published var draftText: String = ""
    @Published var translationResult: String? = nil
    @Published var isShifted: Bool = false
    @Published var isTranslating: Bool = false
    @Published var isOtterPanelOpen: Bool = false
    @Published var keyboardMode: KeyboardMode = .letters
    
    // MARK: - Callbacks to KeyboardViewController
    
    var onInsertText: ((String) -> Void)?
    var onDeleteBackward: (() -> Void)?
    var onSwitchKeyboard: (() -> Void)?
    var onKeyboardHeightChange: ((Bool) -> Void)?
    
    // MARK: - Otter Panel
    
    func toggleOtterPanel() {
        isOtterPanelOpen.toggle()
        onKeyboardHeightChange?(isOtterPanelOpen)
    }
    
    func closeOtterPanel() {
        isOtterPanelOpen = false
        onKeyboardHeightChange?(false)
    }
    
    // MARK: - Typing
    
    func insertText(_ text: String) {
        if isOtterPanelOpen {
            guard draftText.count < 300 else { return }
            draftText += text
        } else {
            onInsertText?(text)
        }
        
        if isShifted {
            isShifted = false
        }
    }
    
    func deleteBackward() {
        if isOtterPanelOpen {
            guard !draftText.isEmpty else { return }
            draftText.removeLast()
        } else {
            onDeleteBackward?()
        }
    }
    
    func clearDraft() {
        draftText = ""
        translationResult = nil
    }
    
    func toggleShift() {
        guard keyboardMode == .letters else { return }
        isShifted.toggle()
    }
    
    func switchKeyboard() {
        onSwitchKeyboard?()
    }
    
    // MARK: - Keyboard Modes
    
    func switchToNumbers() {
        keyboardMode = .numbers
        isShifted = false
    }
    
    func switchToSymbols() {
        keyboardMode = .symbols
        isShifted = false
    }
    
    func switchToLetters() {
        keyboardMode = .letters
    }
    
    // MARK: - Translate
    
//    func translate() {
//        let trimmed = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        guard !trimmed.isEmpty else {
//            isOtterPanelOpen = true
//            onKeyboardHeightChange?(true)
//            return
//        }
//        
//        isOtterPanelOpen = true
//        onKeyboardHeightChange?(true)
//        isTranslating = true
//        
//        // TODO: Replace this with your real model / API call.
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
//            self?.translationResult = "Certainly, I'd be happy to set aside time. I'll send a calendar invite shortly."
//            self?.isTranslating = false
//        }
//    }
    func translate() {
        let trimmed = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            isOtterPanelOpen = true
            onKeyboardHeightChange?(true)
            return
        }
        
        isOtterPanelOpen = true
        onKeyboardHeightChange?(true)
        isTranslating = true
        translationResult = nil
        
        Task { [weak self] in
            do {
                let result = try await StyleTransferService.shared.translate(trimmed)
                
                await MainActor.run {
                    self?.translationResult = result
                    self?.isTranslating = false
                }
            } catch {
                await MainActor.run {
                    self?.translationResult = "Unable to translate. Please check your connection and try again."
                    self?.isTranslating = false
                }
            }
        }
    }
    
    func useTranslation() {
        guard let result = translationResult else { return }
        
        onInsertText?(result)
        
        draftText = ""
        translationResult = nil
        isOtterPanelOpen = false
        onKeyboardHeightChange?(false)
    }
}
