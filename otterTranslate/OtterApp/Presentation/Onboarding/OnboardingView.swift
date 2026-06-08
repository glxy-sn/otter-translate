//
//  OnboardingView.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//


import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.layout) var layout
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void
    
    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            OnboardingPage1View()
                .tag(0)
            OnboardingPage2View()
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.backgroundCream)
        .overlay(alignment: .bottom) {
            bottomControls
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Bottom Controls
    private var bottomControls: some View {
        VStack(spacing: layout.spacingMedium) {
            
            // Page Indicator Dots
            HStack(spacing: layout.spacingXS) {
                ForEach(0..<Constants.Onboarding.totalPages, id: \.self) { index in
                    Capsule()
                        .fill(
                            viewModel.currentPage == index
                            ? Color.primaryBlue
                            : Color.primaryBlue.opacity(0.2)
                        )
                        .frame(
                            width: viewModel.currentPage == index
                                ? layout.spacingLarge
                                : layout.spacingSmall,
                            height: 6
                        )
                        .animation(
                            .spring(duration: Constants.Animation.defaultDuration),
                            value: viewModel.currentPage
                        )
                }
            }
            
            // Buttons
            VStack(spacing: layout.spacingSmall) {
                PrimaryButton(viewModel.primaryButtonTitle) {
                    viewModel.primaryButtonTapped(onComplete: onComplete)
                }
                
                if viewModel.showSecondaryButton {
                    Button {
                        viewModel.secondaryButtonTapped(onComplete: onComplete)
                    } label: {
                        Text(viewModel.secondaryButtonTitle)
                            .font(.system(size: layout.fontBody, weight: .semibold))
                            .foregroundStyle(Color.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, layout.spacingMedium)
                    }
                }
            }
            .padding(.horizontal, layout.horizontalPadding)
        }
        .padding(.bottom, layout.spacingXXL)
        .background(Color.backgroundCream)
    }
}

// MARK: - Page 1
private struct OnboardingPage1View: View {
    
    @Environment(\.layout) var layout
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image("OtterPeeking")
                .resizable()
                .scaledToFit()
                .frame(width: layout.iconSize * 7)
                .zIndex(1)
                .offset(y: layout.iconSize * 0.4)
            
            VStack(alignment: .leading, spacing: layout.spacingMedium) {
                Spacer()
                                .frame(minHeight: layout.spacingXL, maxHeight: layout.spacingXL)
                Text("Type corporate\njargon anywhere.")
                    .font(.system(size: layout.fontLarge, weight: .bold))
                    .foregroundStyle(Color.primaryBlue)
                
                Text("Enable CorpKey Keyboard to translate jargon directly from your keyboard.")
                    .font(.system(size: layout.fontBody, weight: .medium))
                    .foregroundStyle(Color(.systemGray))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, layout.spacingLarge)
            .padding(.top, layout.iconSize * 0.4)
            .padding(.bottom, layout.spacingXXL)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadiusLarge * 2.5))
            .padding(.horizontal, layout.horizontalPadding)
            
            Color.clear
                .frame(height: layout.spacingXXL * 3.5)
        }
        .background(Color.backgroundCream)
    }
}
// MARK: - Page 2
struct OnboardingPage2View: View {
    
    @Environment(\.layout) var layout
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: Main content
            VStack(spacing: 0) {
                
                Spacer()
                    .frame(minHeight: layout.spacingXL, maxHeight: layout.spacingXXL * 2)
                
                VStack(alignment: .leading, spacing: layout.spacingSmall) {
                    Text("Bring CorpKey to\nyour keyboard.")
                        .font(.system(size: layout.fontLarge, weight: .bold))
                        .foregroundStyle(Color.primaryBlue)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Use OtterSpeak while chatting, emailing, or writing work notes.")
                        .font(.system(size: layout.fontBody, weight: .medium))
                        .foregroundStyle(Color(.systemGray))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, layout.horizontalPadding)
                .padding(.bottom, layout.spacingMedium)
                
                Color.clear
                    .frame(height: layout.iconSize * 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    OnboardingStepRow(
                        number: 1,
                        text: Constants.Onboarding.Step.openSettings,
                        showDivider: true
                    )
                    OnboardingStepRow(
                        number: 2,
                        text: Constants.Onboarding.Step.goToKeyboards,
                        showDivider: true
                    )
                    OnboardingStepRow(
                        number: 3,
                        text: Constants.Onboarding.Step.addCorpKey,
                        showDivider: false
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.top, layout.iconSize * 1)
                .padding(.bottom, layout.spacingLarge)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadiusLarge * 2.5))
                .padding(.horizontal, layout.horizontalPadding)
                
                Spacer()
                    .frame(minHeight: layout.spacingXL, maxHeight: layout.spacingXXL * 2)
                
                Color.clear
                    .frame(height: layout.spacingXXL * 3.5)
            }
            
            // Otter — fixed height supaya tidak expand tak terbatas
            GeometryReader { geo in
                if geo.size.width > 0 && geo.size.height > 0 {  // ← guard
                    Image("otterKeyboard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.55)
                        .position(
                            x: geo.size.width / 2,
                            y: geo.size.height * 0.29
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)  // ← tambah ini
            .allowsHitTesting(false)
        }
        .background(Color.backgroundCream)
    }
}

private struct OnboardingStepRow: View {
    
    @Environment(\.layout) var layout
    
    let number: Int
    let text: String
    let showDivider: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(alignment: .center, spacing: layout.spacingMedium) {
                
                ZStack {
                    Circle()
                        .fill(Color.primaryBlue)
                        .frame(width: layout.iconSize, height: layout.iconSize)
                    
                    Text("\(number)")
                        .font(.system(size: layout.fontSmall, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                // Text
                Text(text)
                    .font(.system(size: layout.fontBody, weight: .medium))
                    .foregroundStyle(Color(.systemGray))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, layout.spacingLarge)
            .padding(.vertical, layout.spacingMedium)
            
            if showDivider {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: layout.spacingLarge + layout.iconSize / 2 - 0.75)
                    
                    Rectangle()
                        .fill(Color.primaryBlue.opacity(0.3))
                        .frame(width: 1.5, height: layout.spacingLarge)
                        .mask(
                            VStack(spacing: 3) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Rectangle()
                                        .frame(height: 3)
                                }
                            }
                        )
                    
                    Spacer()
                }
            }
        }
    }
}

