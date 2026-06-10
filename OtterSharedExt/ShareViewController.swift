//
//  ShareViewController.swift
//  OtterSharedExt
//
//  Created by Amelia Citra on 10/06/26.
//

import SwiftUI
import UniformTypeIdentifiers
import UIKit

final class ShareViewController: UIViewController {
    private let viewModel = ShareViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIView()
        loadSharedText()
    }

    private func embedSwiftUIView() {
        let shareView = ShareView(
            viewModel: viewModel,
            onDone: { [weak self] in
                self?.completeShare()
            },
            onCancel: { [weak self] in
                self?.cancelShare()
            }
        )

        let hostingController = UIHostingController(rootView: shareView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        hostingController.didMove(toParent: self)
    }

    private func loadSharedText() {
        Task { @MainActor in
            let sharedText = await firstSharedText()
            viewModel.setInputText(sharedText)
        }
    }

    private func firstSharedText() async -> String? {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return nil
        }

        for item in extensionItems {
            guard let attachments = item.attachments else { continue }

            for provider in attachments {
                if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier),
                   let text = await loadPlainText(from: provider),
                   text.isEmpty == false {
                    return text
                }
            }
        }

        return nil
    }

    private func loadPlainText(from provider: NSItemProvider) async -> String? {
        if let value = await loadStringObject(from: provider), value.isEmpty == false {
            return value
        }

        if let value = await loadPlainTextItem(from: provider), value.isEmpty == false {
            return value
        }

        if let value = await loadPlainTextData(from: provider), value.isEmpty == false {
            return value
        }

        return nil
    }

    private func loadStringObject(from provider: NSItemProvider) async -> String? {
        await withCheckedContinuation { continuation in
            provider.loadObject(ofClass: NSString.self) { object, _ in
                guard let string = object as? String else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: string.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }

    private func loadPlainTextItem(from provider: NSItemProvider) async -> String? {
        await withCheckedContinuation { continuation in
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { item, _ in
                if let string = item as? String {
                    continuation.resume(returning: string.trimmingCharacters(in: .whitespacesAndNewlines))
                    return
                }

                if let attributedString = item as? NSAttributedString {
                    continuation.resume(
                        returning: attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                    return
                }

                if let data = item as? Data,
                   let text = String(data: data, encoding: .utf8) {
                    continuation.resume(returning: text.trimmingCharacters(in: .whitespacesAndNewlines))
                    return
                }

                continuation.resume(returning: nil)
            }
        }
    }

    private func loadPlainTextData(from provider: NSItemProvider) async -> String? {
        await withCheckedContinuation { continuation in
            provider.loadDataRepresentation(forTypeIdentifier: UTType.plainText.identifier) { data, _ in
                guard let data,
                      let text = String(data: data, encoding: .utf8) else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }

    private func completeShare() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    private func cancelShare() {
        let error = NSError(
            domain: "OtterSharedExt",
            code: NSUserCancelledError,
            userInfo: [NSLocalizedDescriptionKey: "User cancelled share flow."]
        )
        extensionContext?.cancelRequest(withError: error)
    }
}
