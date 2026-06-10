//
//  SetupKeyboardView.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 08/06/26.
//

import SwiftUI
import UIKit

struct KeyboardSetupView: View {
    
    @Environment(\.layout) var layout
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundCream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                topBar
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        titleSection
                            .padding(.top, layout.spacingLarge)
                        
                        otterIllustration
                            .padding(.top, layout.spacingSmall)
                        
                        instructionCard
                            .padding(.top, -layout.spacingLarge)
                    }
                    .padding(.horizontal, layout.horizontalPadding)
                    .padding(.bottom, layout.spacingXXL)
                }
                
                bottomSection
            }
        }
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: layout.fontBody, weight: .bold))
                    .foregroundStyle(Color.primaryBlue)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.75))
                    .clipShape(Circle())
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, layout.horizontalPadding)
        .padding(.top, layout.spacingLarge)
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: layout.spacingMedium) {
            Text("Bring CorpKey to\nyour keyboard.")
                .font(.system(size: layout.fontHero * 0.78, weight: .bold))
                .foregroundStyle(Color.primaryBlue)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Use OtterSpeak while chatting, emailing, or writing work notes.")
                .font(.system(size: layout.fontTitle * 0.92, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.75))
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Otter Illustration
    private var otterIllustration: some View {
        HStack {
            Spacer()
            
            Image("otterKeyboard")
                .resizable()
                .scaledToFit()
                .frame(width: layout.width * 0.58)
            
            Spacer()
        }
    }
    
    // MARK: - Instruction Card
    private var instructionCard: some View {
        VStack(spacing: 0) {
            setupStep(
                number: "1",
                title: "Open iPhone Settings",
                showLine: true
            )
            
            setupStep(
                number: "2",
                title: "Go to Keyboard > Keyboards",
                showLine: true
            )
            
            setupStep(
                number: "3",
                title: "Add CorpKey Keyboard",
                showLine: false
            )
        }
        .padding(.horizontal, layout.spacingLarge)
        .padding(.vertical, layout.spacingXL)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadiusLarge * 2.2))
    }
    
    private func setupStep(
        number: String,
        title: String,
        showLine: Bool
    ) -> some View {
        HStack(alignment: .top, spacing: layout.spacingLarge) {
            
            VStack(spacing: layout.spacingSmall) {
                Text(number)
                    .font(.system(size: layout.fontBody, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Color.primaryBlue)
                    .clipShape(Circle())
                
                if showLine {
                    Rectangle()
                        .fill(Color.primaryBlue.opacity(0.22))
                        .frame(width: 2, height: layout.spacingXL)
                        .overlay {
                            VStack(spacing: 5) {
                                ForEach(0..<3, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.primaryBlue.opacity(0.25))
                                        .frame(width: 3, height: 3)
                                }
                            }
                        }
                }
            }
            
            Text(title)
                .font(.system(size: layout.fontTitle * 0.9, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.75))
                .padding(.top, 2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 0)
        }
        .padding(.bottom, showLine ? layout.spacingMedium : 0)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: layout.spacingLarge) {
            
            pageIndicator
            
            PrimaryButton("Open Settings") {
                openAppSettings()
            }
        }
        .padding(.horizontal, layout.horizontalPadding)
        .padding(.bottom, layout.spacingLarge)
        .background(
            Color.backgroundCream
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(Color.primaryBlue.opacity(0.22))
                .frame(width: 16, height: 6)
            
            Capsule()
                .fill(Color.primaryBlue)
                .frame(width: 26, height: 6)
        }
    }
    
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

// MARK: - Preview
#Preview {
    KeyboardSetupView()
        .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
