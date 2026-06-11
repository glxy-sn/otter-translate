//
//  ShareView.swift
//  OtterSharedExt
//

import SwiftUI

struct ShareView: View {
    @ObservedObject var viewModel: ShareViewModel

    let onDone: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color(red: 0.10, green: 0.24, blue: 0.63).ignoresSafeArea()

            if let entry = viewModel.entry {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.term.lowercased())
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 16)

                        divider
                            .padding(.bottom, 16)

                        section(
                            title: "Meaning",
                            content: "Text yang kamu pilih dari Messages akan dipakai sebagai term untuk diproses di OtterTranslate."
                        )
                        .padding(.bottom, 16)

                        divider
                            .padding(.bottom, 16)

                        section(
                            title: "Indirect Example",
                            content: "\"\(entry.term)\""
                        )
                        .padding(.bottom, 16)

                        section(
                            title: "OtterTranslate",
                            content: "Slide down sheet ini untuk kembali ke Messages."
                        )
                        .padding(.bottom, 24)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No text found",
                    systemImage: "text.quote",
                    description: Text("Pilih teks message lalu share kembali ke OtterTranslate.")
                )
                .foregroundStyle(.white)
            }
        }
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
        .presentationBackground(Color(red: 0.10, green: 0.24, blue: 0.63))
    }

    private var divider: some View {
        Rectangle()
            .fill(.white.opacity(0.2))
            .frame(height: 0.5)
            .padding(.horizontal, 20)
    }

    private func section(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.6))

            Text(content)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    let viewModel = ShareViewModel()
    viewModel.setInputText("Message text from iMessage")
    return ShareView(viewModel: viewModel, onDone: {}, onCancel: {})
}
