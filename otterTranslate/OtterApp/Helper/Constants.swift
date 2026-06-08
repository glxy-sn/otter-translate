//
//  Constants.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import UIKit

enum Constants {
    
    enum AppInfo {
        static let appName = "Otter Translate"
        static let tagline = "speak the language of the office"
        static let totalJargon = 302
    }
    
    enum AppGroup {
        static let identifier = "com.tiara.otterTranslate"
    }
    
    enum UserDefaultsKey {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let isKeyboardEnabled      = "isKeyboardEnabled"
        static let isHapticEnabled        = "isHapticEnabled"
        static let isDarkMode             = "isDarkMode"
    }
    
    enum Animation {
        static let defaultDuration: Double = 0.3
        static let springDamping: Double   = 0.8
        static let springVelocity: Double  = 0.5
    }
    
    
    enum CSV {
        static let jargonFileName      = "jargon-dictionary"
        static let jargonFileExtension = "csv"
    }
    
    enum Onboarding {
        static let totalPages = 2
        
        enum Step {
            static let openSettings  = "Open iPhone Settings"
            static let goToKeyboards = "Go to Keyboard > Keyboards"
            static let addCorpKey    = "Add CorpKey Keyboard"
        }
    }
    
    enum Alphabet {
        static let letters = ["#","A","B","C","D","E","F","G","H",
                              "I","J","K","L","M","N","O","P",
                              "Q","R","S","T","U","V","W","X",
                              "Y","Z"]
    }
}
