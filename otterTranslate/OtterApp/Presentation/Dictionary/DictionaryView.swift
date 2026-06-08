//
//  DictionaryView.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 06/06/26.
//
import SwiftUI

struct DictionaryView: View {
    
    @Environment(\.layout) var layout
    @StateObject private var viewModel = DictionaryViewModel()
    
    @State private var detailEntry: JargonEntry?
    @State private var requestedScrollID: UUID?
    @State private var showKeyboardSetup = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.backgroundCream
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: layout.spacingMedium) {
                    
                    header
                    
//                    if viewModel.showBanner {
//                        KeyboardExtensionBanner {
////                            viewModel.onSetupTapped()
//                            showKeyboardSetup = true
//                        }
//                    }
                    
                    
                    SearchBar(
                        text: $viewModel.searchText,
                        placeholder: "Search jargon..."
                    )
                    .zIndex(10)
                    
                    dictionaryContent
                        .zIndex(1)
                }
                .padding(.horizontal, layout.cardPadding)
                .padding(.top, safeTopPadding(from: geo))
                .padding(.bottom, geo.safeAreaInsets.bottom + layout.spacingSmall)
            }
        }
        .onChange(of: viewModel.searchText) { _, _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                viewModel.resetSelectionIfNeeded()
                requestedScrollID = viewModel.selectedEntry?.id
            }
        }
        .sheet(item: $detailEntry) { entry in
            GeometryReader { geo in
                DictionaryDetailView(entry: entry)
                    .environment(
                        \.layout,
                         LayoutConstants(
                            width: geo.size.width,
                            height: geo.size.height
                         )
                    )
            }
        }
    }
    
    // MARK: - Safe Top Padding
    private func safeTopPadding(from geo: GeometryProxy) -> CGFloat {
        geo.safeAreaInsets.top + layout.spacingXXL + layout.spacingSmall
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: layout.spacingXS * 0.4) {
            Text("OtterSpeak")
                .font(.system(size: layout.fontLarge * 1.25, weight: .bold))
                .foregroundStyle(Color.primaryBlue)
            
            Text("Decode workplace jargon")
                .font(.system(size: layout.fontSmall, weight: .semibold))
                .foregroundStyle(Color.primaryBlue.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Dictionary Content
    private var dictionaryContent: some View {
        ZStack(alignment: .topTrailing) {
            
            if viewModel.filteredEntries.isEmpty {
                emptyState
            } else {
                JargonWheelView(
                    entries: viewModel.filteredEntries,
                    selectedEntry: viewModel.selectedEntry,
                    requestedScrollID: requestedScrollID,
                    onCenteredEntryChange: { entry in
                        viewModel.updateCenteredEntry(entry)
                    },
                    onTapEntry: { entry in
                        detailEntry = entry
                    }
                )
                .padding(.trailing, layout.alphaPickerWidth + layout.spacingSmall)
                .clipped()
            }
            
            AlphabetPickerView(
                alphabet: viewModel.alphabet,
                selectedLetter: viewModel.selectedLetter
            ) { letter in
                if let target = viewModel.selectLetter(letter) {
                    requestedScrollID = target.id
                }
            }
            .offset(x: 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, layout.spacingSmall)
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: layout.spacingSmall) {
            Image("OtterLooking")
                .resizable()
                .scaledToFit()
                .frame(width: layout.iconSize * 5)
            
            Text("No jargon found")
                .font(.system(size: layout.fontBody, weight: .semibold))
                .foregroundStyle(Color.primaryBlue.opacity(0.75))
            
            Text("Try another corporate term.")
                .font(.system(size: layout.fontSmall))
                .foregroundStyle(Color.primaryBlue.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, layout.spacingLarge)
    }
}

// MARK: - Preview
#Preview {
    DictionaryView()
        .environment(\.layout, LayoutConstants(width: 390, height: 844))
}


//
//import SwiftUI
//
//struct DictionaryView: View {
//    
//    @Environment(\.layout) var layout
//    @StateObject private var viewModel = DictionaryViewModel()
//    
//    @State private var detailEntry: JargonEntry?
//    @State private var requestedScrollID: UUID?
//    @State private var showSetupScreen: Bool = false  // ← tambah
//    
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                Color.backgroundCream
//                    .ignoresSafeArea()
//                
//                VStack(alignment: .leading, spacing: layout.spacingMedium) {
//                    
//                    header
//                    
//                    // ← wrap dengan kondisi
//                    if viewModel.showBanner {
//                        KeyboardExtensionBanner {
//                            showSetupScreen = true
//                        }
//                    }
//                    
//                    SearchBar(
//                        text: $viewModel.searchText,
//                        placeholder: "Search jargon..."
//                    )
//                    .zIndex(10)
//                    
//                    dictionaryContent
//                        .zIndex(1)
//                }
//                .padding(.horizontal, layout.cardPadding)
//                .padding(.top, safeTopPadding(from: geo))
//                .padding(.bottom, geo.safeAreaInsets.bottom + layout.spacingSmall)
//            }
//        }
//        .onChange(of: viewModel.searchText) { _, _ in
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
//                viewModel.resetSelectionIfNeeded()
//                requestedScrollID = viewModel.selectedEntry?.id
//            }
//        }
//        .sheet(item: $detailEntry) { entry in
//            GeometryReader { geo in
//                DictionaryDetailView(entry: entry)
//                    .environment(
//                        \.layout,
//                        LayoutConstants(
//                            width: geo.size.width,
//                            height: geo.size.height
//                        )
//                    )
//            }
//        }
//        // ← tambah fullScreenCover
//        .fullScreenCover(isPresented: $showSetupScreen) {
//            GeometryReader { geo in
//                ZStack(alignment: .topTrailing) {
//                    
//                    OnboardingPage2View()
//                    
//                    // X Button
//                    Button {
//                        showSetupScreen = false
//                    } label: {
//                        Image(systemName: "xmark")
//                            .font(.system(size: layout.fontBody, weight: .medium))
//                            .foregroundStyle(Color.primaryBlue)
//                            .padding(layout.spacingSmall)
//                            .background(Color.primaryBlue.opacity(0.08))
//                            .clipShape(Circle())
//                    }
//                    .padding(.top, geo.safeAreaInsets.top + layout.spacingMedium)
//                    .padding(.trailing, layout.horizontalPadding)
//                }
//                .environment(\.layout, LayoutConstants(
//                    width: geo.size.width,
//                    height: geo.size.height
//                ))
//            }
//            .ignoresSafeArea()
//        }
//    }
//    
//    // MARK: - Safe Top Padding
//    private func safeTopPadding(from geo: GeometryProxy) -> CGFloat {
//        geo.safeAreaInsets.top + layout.spacingXXL + layout.spacingSmall
//    }
//    
//    // MARK: - Header
//    private var header: some View {
//        VStack(alignment: .leading, spacing: layout.spacingXS * 0.4) {
//            Text("OtterSpeak")
//                .font(.system(size: layout.fontLarge * 1.25, weight: .bold))
//                .foregroundStyle(Color.primaryBlue)
//            
//            Text("Decode workplace jargon")
//                .font(.system(size: layout.fontSmall, weight: .semibold))
//                .foregroundStyle(Color.primaryBlue.opacity(0.75))
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//    
//    // MARK: - Dictionary Content
//    private var dictionaryContent: some View {
//        ZStack(alignment: .topTrailing) {
//            
//            if viewModel.filteredEntries.isEmpty {
//                emptyState
//            } else {
//                JargonWheelView(
//                    entries: viewModel.filteredEntries,
//                    selectedEntry: viewModel.selectedEntry,
//                    requestedScrollID: requestedScrollID,
//                    onCenteredEntryChange: { entry in
//                        viewModel.updateCenteredEntry(entry)
//                    },
//                    onTapEntry: { entry in
//                        detailEntry = entry
//                    }
//                )
//                .padding(.trailing, layout.alphaPickerWidth + layout.spacingSmall)
//                .clipped()
//            }
//            
//            AlphabetPickerView(
//                alphabet: viewModel.alphabet,
//                selectedLetter: viewModel.selectedLetter
//            ) { letter in
//                if let target = viewModel.selectLetter(letter) {
//                    requestedScrollID = target.id
//                }
//            }
//            .offset(x: 4)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .padding(.top, layout.spacingSmall)
//    }
//    
//    // MARK: - Empty State
//    private var emptyState: some View {
//        VStack(spacing: layout.spacingSmall) {
//            Image("OtterLooking")
//                .resizable()
//                .scaledToFit()
//                .frame(width: layout.iconSize * 5)
//            
//            Text("No jargon found")
//                .font(.system(size: layout.fontBody, weight: .semibold))
//                .foregroundStyle(Color.primaryBlue.opacity(0.75))
//            
//            Text("Try another corporate term.")
//                .font(.system(size: layout.fontSmall))
//                .foregroundStyle(Color.primaryBlue.opacity(0.5))
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.top, layout.spacingLarge)
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    DictionaryView()
//        .environment(\.layout, LayoutConstants(width: 390, height: 844))
//}
