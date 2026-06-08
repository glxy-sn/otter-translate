//
//  Layout.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import SwiftUI

struct LayoutConstants {
    let width: CGFloat
    let height: CGFloat
    
    // Pastikan semua computed values selalu positif
    private var safeWidth: CGFloat { max(width, 1) }
    private var safeHeight: CGFloat { max(height, 1) }
    
    var horizontalPadding: CGFloat { safeWidth * 0.05 }
    var cardPadding: CGFloat       { safeWidth * 0.04 }
    var cornerRadius: CGFloat      { safeWidth * 0.03 }
    var cornerRadiusLarge: CGFloat { safeWidth * 0.04 }
    var iconSize: CGFloat          { safeWidth * 0.06 }
    var alphaPickerWidth: CGFloat  { safeWidth * 0.05 }
    
    var fontXS: CGFloat    { safeWidth * 0.028 }
    var fontSmall: CGFloat { safeWidth * 0.033 }
    var fontBody: CGFloat  { safeWidth * 0.038 }
    var fontTitle: CGFloat { safeWidth * 0.055 }
    var fontLarge: CGFloat { safeWidth * 0.075 }
    var fontHero: CGFloat  { safeWidth * 0.11  }
    
    var spacingXS: CGFloat     { safeWidth * 0.02 }
    var spacingSmall: CGFloat  { safeWidth * 0.03 }
    var spacingMedium: CGFloat { safeWidth * 0.04 }
    var spacingLarge: CGFloat  { safeWidth * 0.06 }
    var spacingXL: CGFloat     { safeWidth * 0.08 }
    var spacingXXL: CGFloat    { safeWidth * 0.12 }
}
