//
//  RootView.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//


import SwiftUI

struct RootView: View {
    
    @Environment(\.layout) var layout
    @State private var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(
        forKey: Constants.UserDefaultsKey.hasCompletedOnboarding
    )
    
    var body: some View {
        if hasCompletedOnboarding {
            DictionaryView()
        } else {
            OnboardingView(onComplete: {
                withAnimation {
                    hasCompletedOnboarding = true
                }
            })
        }
    }
}
