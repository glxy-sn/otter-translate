//// KeyboardViewController.swift
//// OtterKeyboard
//
//import UIKit
//import SwiftUI
//
//class KeyboardViewController: UIInputViewController {
//    
//    private var viewModel = KeyboardViewModel()
//    private var hostingController: UIHostingController<AnyView>?
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViewModel()
//        setupKeyboardView()
//        preferredContentSize = CGSize(width: 0, height: 340)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateLayout()
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        updateLayout()
//    }
//    
//    // MARK: - Setup
//    private func setupViewModel() {
//        viewModel.onInsertText = { [weak self] text in
//            self?.textDocumentProxy.insertText(text)
//        }
//        viewModel.onDeleteBackward = { [weak self] in
//            self?.textDocumentProxy.deleteBackward()
//        }
//        viewModel.onSwitchKeyboard = { [weak self] in
//            self?.advanceToNextInputMode()
//        }
//    }
//    
//    private func setupKeyboardView() {
//        let width  = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width
//        let height = view.bounds.height > 0 ? view.bounds.height : 340
//        
//        let layout = LayoutConstants(width: width, height: height)
//        
//        let keyboardView = AnyView(
//            KeyboardView(viewModel: viewModel)
//                .environment(\.layout, layout)
//        )
//        
//        let hosting = UIHostingController(rootView: keyboardView)
//        hosting.view.translatesAutoresizingMaskIntoConstraints = false
//        hosting.view.backgroundColor = .clear
//        
//        addChild(hosting)
//        view.addSubview(hosting.view)
//        hosting.didMove(toParent: self)
//        
//        NSLayoutConstraint.activate([
//            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        hostingController = hosting
//    }
//    
//    private func updateLayout() {
//        guard let hosting = hostingController else { return }
//        
//        let width  = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width
//        let layout = LayoutConstants(width: width, height: 340)
//        
//        hosting.rootView = AnyView(
//            KeyboardView(viewModel: viewModel)
//                .environment(\.layout, layout)
//        )
//        
//        preferredContentSize = CGSize(width: 0, height: 380)
//    }
//    
//    // MARK: - Text Input
//    override func textWillChange(_ textInput: UITextInput?) {
//        super.textWillChange(textInput)
//    }
//    
//    override func textDidChange(_ textInput: UITextInput?) {
//        super.textDidChange(textInput)
//    }
//}
//
//  KeyboardViewController.swift
//  OtterKeyboard
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {
    
    private var viewModel = KeyboardViewModel()
    private var hostingController: UIHostingController<AnyView>?
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Height
    
    private let collapsedHeight: CGFloat = 216
    private let expandedHeight: CGFloat = 305
    
    private var currentHeight: CGFloat = 216
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupViewModel()
        setupKeyboardView()
        setKeyboardHeight(collapsedHeight, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayout()
    }
    
    // MARK: - Setup
    
    private func setupViewModel() {
        viewModel.onInsertText = { [weak self] text in
            self?.textDocumentProxy.insertText(text)
        }
        
        viewModel.onDeleteBackward = { [weak self] in
            self?.textDocumentProxy.deleteBackward()
        }
        
        viewModel.onSwitchKeyboard = { [weak self] in
            self?.advanceToNextInputMode()
        }
        
        viewModel.onKeyboardHeightChange = { [weak self] isExpanded in
            guard let self else { return }
            
            self.setKeyboardHeight(
                isExpanded ? self.expandedHeight : self.collapsedHeight,
                animated: true
            )
        }
    }
    
    private func setupKeyboardView() {
        let width = view.bounds.width > 0
        ? view.bounds.width
        : UIScreen.main.bounds.width
        
        let layout = LayoutConstants(
            width: width,
            height: currentHeight
        )
        
        let keyboardView = AnyView(
            KeyboardView(viewModel: viewModel)
                .environment(\.layout, layout)
        )
        
        let hosting = UIHostingController(rootView: keyboardView)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear
        
        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController = hosting
    }
    
    // MARK: - Height
    
    private func setKeyboardHeight(_ height: CGFloat, animated: Bool) {
        currentHeight = height
        preferredContentSize = CGSize(width: 0, height: height)
        
        if heightConstraint == nil {
            heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            heightConstraint?.priority = .required
            heightConstraint?.isActive = true
        } else {
            heightConstraint?.constant = height
        }
        
        updateLayout()
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }
    
    private func updateLayout() {
        guard let hostingController else { return }
        
        let width = view.bounds.width > 0
        ? view.bounds.width
        : UIScreen.main.bounds.width
        
        let layout = LayoutConstants(
            width: width,
            height: currentHeight
        )
        
        hostingController.rootView = AnyView(
            KeyboardView(viewModel: viewModel)
                .environment(\.layout, layout)
        )
    }
}
