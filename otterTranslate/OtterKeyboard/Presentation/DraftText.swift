//
//  DraftText.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 10/06/26.
//

import SwiftUI
import UIKit

struct DraftTextDisplay: View {
    
    let text: String
    @State private var showCursor = true
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                Text(text + "▏")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .id("draft-bottom")
                    .opacity(text.isEmpty ? 0 : 1)
            }
            .onChange(of: text) { _ in
                withAnimation(.easeOut(duration: 0.12)) {
                    proxy.scrollTo("draft-bottom", anchor: .bottom)
                }
            }
        }
    }
}
