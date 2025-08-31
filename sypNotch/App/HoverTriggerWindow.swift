//
//  HoverTriggerWindow.swift
//  sypNotch
//
//  Created by SYP on 31/8/25.
//

import AppKit

final class HoverTriggerWindow: NSWindow {
    var onHoverChange: ((Bool) -> Void)?
    private let width: CGFloat
    private let height: CGFloat = 8

    init(width: CGFloat) {
        self.width = width
        let frame = HoverTriggerWindow.topCentered(width: width, height: 8)
        super.init(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        level = .statusBar
        isOpaque = false
        backgroundColor = .clear
        hasShadow = false
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        let opts: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways, .inVisibleRect]
        let area = NSTrackingArea(rect: .zero, options: opts, owner: self, userInfo: nil)
        contentView?.addTrackingArea(area)
    }

    static func topCentered(width: CGFloat, height: CGFloat) -> NSRect {
        let s = NSScreen.main?.visibleFrame ?? .zero
        return NSRect(x: s.minX + (s.width - width)/2, y: s.maxY - height, width: width, height: height)
    }

    override func mouseEntered(with event: NSEvent) { onHoverChange?(true) }
    override func mouseExited(with event: NSEvent)  { onHoverChange?(false) }
}
