//
//  OnboardingViewModel.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var currentPage: Int = 0
    
    // MARK: - Computed Properties
    var primaryButtonTitle: String {
        switch currentPage {
        case 0:  return "Enable Keyboard Extension"
        case 1:  return "Open Settings"
        default: return "Continue"
        }
    }
    
    var secondaryButtonTitle: String {
        switch currentPage {
        case 0:  return "Continue to Dictionary"
        default: return ""
        }
    }
    
    var showSecondaryButton: Bool {
        currentPage == 0
    }
    
    func primaryButtonTapped(onComplete: () -> Void) {
        switch currentPage {
        case 0:
            // Page 1 — Enable Keyboard Extension
            // Nanti: buka iOS Settings untuk aktifkan keyboard
            withAnimation {
                currentPage = 1
            }
        case 1:
            // Page 2 — Open Settings
            // Buka iOS Settings
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        default:
            break
        }
    }

    func secondaryButtonTapped(onComplete: () -> Void) {
        // Continue to Dictionary — selesaikan onboarding
        completeOnboarding()
        onComplete()
    }

    func completeOnboarding() {
        UserDefaults.standard.set(
            true,
            forKey: Constants.UserDefaultsKey.hasCompletedOnboarding
        )
    }
}
