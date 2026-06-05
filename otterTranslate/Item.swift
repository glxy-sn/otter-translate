//
//  Item.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
