//
//  OtterTranslateApp.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//


import SwiftUI

@main
struct otterTranslateApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                RootView()
                    .environment(\.layout, LayoutConstants(
                        width: geo.size.width,
                        height: geo.size.height
                    ))
            }
            .ignoresSafeArea()
        }
    }
}
