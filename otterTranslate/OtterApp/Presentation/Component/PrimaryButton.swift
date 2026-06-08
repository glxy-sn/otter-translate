//
//  PrimaryButton.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//


import SwiftUI

enum PrimaryButtonStyle {
    case filled
    case outlined
    
    func backgroundColor(isPressed: Bool) -> Color {
        switch self {
        case .filled:   return isPressed ? Color.primaryBlue.opacity(0.85) : Color.primaryBlue
        case .outlined: return .clear
        }
    }
    
    func foregroundColor() -> Color {
        switch self {
        case .filled:   return .white
        case .outlined: return Color.primaryBlue
        }
    }
    
    func borderColor() -> Color {
        switch self {
        case .filled:   return .clear
        case .outlined: return Color.primaryBlue
        }
    }
}

struct PrimaryButton: View {
    
    @Environment(\.layout) var layout
    
    let title: String
    let style: PrimaryButtonStyle
    let action: () -> Void
    
    @State private var isPressed = false
    
    // MARK: - Init
    init(
        _ title: String,
        style: PrimaryButtonStyle = .filled,
        action: @escaping () -> Void
    ) {
        self.title  = title
        self.style  = style
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: layout.fontBody, weight: .semibold))
                .foregroundStyle(style.foregroundColor())
                .frame(maxWidth: .infinity)
                .padding(.vertical, layout.spacingMedium)
                .background(style.backgroundColor(isPressed: isPressed))
                .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius * 2.5))
                .overlay(
                    RoundedRectangle(cornerRadius: layout.cornerRadius * 2.5)
                        .stroke(style.borderColor(), lineWidth: 1.5)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(
                .spring(
                    duration: Constants.Animation.defaultDuration,
                    bounce: Constants.Animation.springDamping
                ),
                value: configuration.isPressed
            )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        PrimaryButton("Enable Keyboard Extension") {
            print("tapped filled")
        }
        
        PrimaryButton("Continue to Dictionary", style: .outlined) {
            print("tapped outlined")
        }
    }
    .padding()
    .environment(\.layout, LayoutConstants(width: 390, height: 844))
}
