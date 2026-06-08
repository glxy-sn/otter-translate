//
//  LayoutEnv.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import SwiftUI

private struct LayoutConstantsKey: EnvironmentKey {
    static let defaultValue = LayoutConstants(width: 390, height: 844)
}

extension EnvironmentValues {
    var layout: LayoutConstants {
        get { self[LayoutConstantsKey.self] }
        set { self[LayoutConstantsKey.self] = newValue }
    }
}
