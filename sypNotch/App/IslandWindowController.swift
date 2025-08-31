    //
//  IslandWindowController.swift
//  sypNotch
//
//  Created by Paula on 31/8/25.
//

import AppKit
import SwiftUI

final class IslandWindowController: NSWindowController {
    private var visible = false
    private var hideWork: DispatchWorkItem?

    convenience init(rootView: some View) {
        let size = NSSize(width: 520, height: 220)
        let frame = Self.topCentered(size: size, topPadding: 10)

        let win = NSPanel(contentRect: frame, styleMask: [.borderless, .nonactivatingPanel],
                          backing: .buffered, defer: false)
        win.level = .statusBar
        win.isOpaque = false
        win.backgroundColor = .clear
        win.hasShadow = true
        win.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        self.init(window: win)
        let hosting = NSHostingView(rootView: AnyView(rootView))
        hosting.frame = win.contentView!.bounds
        hosting.autoresizingMask = [.width, .height]
        win.contentView?.addSubview(hosting)
    }

    static func topCentered(size: NSSize, topPadding: CGFloat) -> NSRect {
        let s = NSScreen.main?.visibleFrame ?? .zero
        return NSRect(x: s.minX + (s.width - size.width)/2,
                      y: s.maxY - size.height - topPadding,
                      width: size.width, height: size.height)
    }

    func show() {
        hideWork?.cancel()
        guard let w = window, !visible else { return }
        visible = true; w.alphaValue = 0; w.makeKeyAndOrderFront(nil)
        NSAnimationContext.runAnimationGroup { ctx in ctx.duration = 0.12; w.animator().alphaValue = 1 }
    }

    func hide() {
        guard let w = window, visible else { return }
        visible = false
        NSAnimationContext.runAnimationGroup({ ctx in ctx.duration = 0.10; w.animator().alphaValue = 0 },
                                             completionHandler: { w.orderOut(nil); w.alphaValue = 1 })
    }

    func hideDelayed(_ delay: TimeInterval = 0.35) {
        hideWork?.cancel()
        let work = DispatchWorkItem { [weak self] in self?.hide() }
        hideWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    func toggle() { visible ? hide() : show() }
}
