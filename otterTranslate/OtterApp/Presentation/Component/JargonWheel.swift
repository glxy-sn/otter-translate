//
//  JargonWheel.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 08/06/26.
//
import SwiftUI
import UIKit

private struct JargonCenterPreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGFloat] = [:]
    
    static func reduce(value: inout [UUID: CGFloat], nextValue: () -> [UUID: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct JargonWheelView: View {
    
    @Environment(\.layout) var layout
    
    let entries: [JargonEntry]
    let selectedEntry: JargonEntry?
    let requestedScrollID: UUID?
    let onCenteredEntryChange: (JargonEntry) -> Void
    let onTapEntry: (JargonEntry) -> Void
    
    @State private var centeredEntryID: UUID?
    @State private var lastDragStep: Int = 0
    
    private let coordinateSpaceName = "JargonWheelScroll"
    
    var body: some View {
        ScrollViewReader { proxy in
            GeometryReader { containerGeo in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: layout.spacingXS) {
                        
                        Color.clear
                            .frame(height: topSpacerHeight)
                        
                        ForEach(entries) { entry in
                            wheelRow(entry: entry)
                                .id(entry.id)
                        }
                        
                        Color.clear
                            .frame(height: bottomSpacerHeight(containerHeight: containerGeo.size.height))
                    }
                }
                .coordinateSpace(name: coordinateSpaceName)
                .clipped()
                .simultaneousGesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged { value in
                            let step = Int(value.translation.height / rowHeight)
                            
                            if step != lastDragStep {
                                lastDragStep = step
                                selectionHaptic()
                            }
                        }
                        .onEnded { _ in
                            lastDragStep = 0
                        }
                )
                .onPreferenceChange(JargonCenterPreferenceKey.self) { distances in
                    guard let closestID = distances.min(by: { $0.value < $1.value })?.key,
                          closestID != centeredEntryID,
                          let entry = entries.first(where: { $0.id == closestID }) else {
                        return
                    }
                    
                    centeredEntryID = closestID
                    selectionHaptic()
                    onCenteredEntryChange(entry)
                }
                .onAppear {
                    scrollToInitialEntry(using: proxy)
                }
                .onChange(of: requestedScrollID) { _, newValue in
                    guard let newValue else { return }
                    
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                        proxy.scrollTo(newValue, anchor: .top)
                    }
                }
                .onChange(of: entries) { _, _ in
                    guard let target = selectedEntry ?? entries.first else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                            proxy.scrollTo(target.id, anchor: .top)
                        }
                    }
                }
            }
        }
    }
    
    private func wheelRow(entry: JargonEntry) -> some View {
        GeometryReader { geo in
            let midY = geo.frame(in: .named(coordinateSpaceName)).midY
            let distance = abs(midY - focusY)
            let progress = min(distance / 185, 1)
            
            let scale = 1.0 - (0.36 * progress)
            let opacity = 1.0 - (0.72 * Double(progress))
            let blur = progress * 0.72
            
            Text(entry.term.lowercased())
                .font(.system(
                    size: layout.fontLarge * 2.0,
                    weight: selectedEntry?.id == entry.id ? .bold : .semibold,
                    design: .serif
                ))
                .foregroundStyle(Color.primaryBlue)
                .frame(maxWidth: .infinity)
                .frame(height: rowHeight)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
                .scaleEffect(scale)
                .opacity(opacity)
                .blur(radius: blur)
                .contentShape(Rectangle())
                .onTapGesture {
                    impactHaptic()
                    onTapEntry(entry)
                }
                .background(
                    GeometryReader { itemGeo in
                        let itemMidY = itemGeo.frame(in: .named(coordinateSpaceName)).midY
                        let itemDistance = abs(itemMidY - focusY)
                        
                        Color.clear.preference(
                            key: JargonCenterPreferenceKey.self,
                            value: [entry.id: itemDistance]
                        )
                    }
                )
        }
        .frame(height: rowHeight)
    }
    
    private var rowHeight: CGFloat {
        layout.fontLarge * 2.1
    }
    
    private var focusY: CGFloat {
        rowHeight * 0.65
    }
    
    private var topSpacerHeight: CGFloat {
        max(0, focusY - rowHeight / 2)
    }
    
    private func bottomSpacerHeight(containerHeight: CGFloat) -> CGFloat {
        max(0, containerHeight - focusY - rowHeight / 2)
    }
    
    private func scrollToInitialEntry(using proxy: ScrollViewProxy) {
        guard let target = selectedEntry ?? entries.first else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            proxy.scrollTo(target.id, anchor: .top)
        }
    }
    
    private func selectionHaptic() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    private func impactHaptic() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
