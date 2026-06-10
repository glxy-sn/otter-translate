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
        NavigationStack {
            Group {
                if let entry = viewModel.entry {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("entry.term")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(entry.term)
                            .font(.title3.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                } else {
                    ContentUnavailableView(
                        "No text found",
                        systemImage: "text.quote",
                        description: Text("Pilih teks message lalu share kembali ke OtterTranslate.")
                    )
                }
            }
            .navigationTitle("OtterTranslate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { onCancel() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { onDone() }
                }
            }
        }
    }
}

#Preview {
    let viewModel = ShareViewModel()
    viewModel.setInputText("Message text from iMessage")
    return ShareView(viewModel: viewModel, onDone: {}, onCancel: {})
}
