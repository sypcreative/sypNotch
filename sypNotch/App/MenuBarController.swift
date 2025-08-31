//
//  MenuBarController.swift
//  sypNotch
//
//  Created by SYP on 31/8/25.
//

import AppKit
import SwiftUI

final class MenuBarController {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let popover = NSPopover()
    var onToggleIsland: (() -> Void)?

    init(rootView: AnyView) {
        if let b = statusItem.button {
            b.image = NSImage(systemSymbolName: "circle.grid.2x2", accessibilityDescription: "sypNotch")
            b.action = #selector(togglePopover); b.target = self
        }
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 320, height: 200)
        popover.contentViewController = NSHostingController(rootView: rootView)

        let menu = NSMenu()
        let toggle = NSMenuItem(title: "Toggle Island", action: #selector(toggleIsland), keyEquivalent: "i"); toggle.target = self
        let quit = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"); quit.target = self
        menu.addItem(toggle); menu.addItem(.separator()); menu.addItem(quit)
        statusItem.menu = menu
    }

    @objc private func togglePopover() {
        guard let b = statusItem.button else { return }
        popover.isShown ? popover.performClose(nil)
                        : popover.show(relativeTo: b.bounds, of: b, preferredEdge: .minY)
    }
    @objc private func toggleIsland() { onToggleIsland?() }
    @objc private func quit() { NSApp.terminate(nil) }
}
