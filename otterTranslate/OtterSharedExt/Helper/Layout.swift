//
//  Layout.swift
//  OtterSharedExt
//

import SwiftUI

struct LayoutConstants {
    let width: CGFloat
    let height: CGFloat

    private var safeWidth: CGFloat { max(width, 1) }

    var horizontalPadding: CGFloat { safeWidth * 0.05 }
    var cardPadding: CGFloat { safeWidth * 0.04 }
    var cornerRadiusLarge: CGFloat { safeWidth * 0.04 }
    var iconSize: CGFloat { safeWidth * 0.06 }

    var fontXS: CGFloat { safeWidth * 0.028 }
    var fontSmall: CGFloat { safeWidth * 0.033 }
    var fontBody: CGFloat { safeWidth * 0.038 }
    var fontTitle: CGFloat { safeWidth * 0.055 }
    var fontHero: CGFloat { safeWidth * 0.11 }

    var spacingSmall: CGFloat { safeWidth * 0.03 }
    var spacingLarge: CGFloat { safeWidth * 0.06 }
    var spacingXXL: CGFloat { safeWidth * 0.12 }
}
