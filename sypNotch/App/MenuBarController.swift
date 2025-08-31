//
//  MenuBarController.swift
//  sypNotch
//
//  Created by SYP on 31/8/25.
//
//
//  MenuBarController.swift
//  sypNotch
//

import AppKit
import SwiftUI

final class MenuBarController {
    let statusItem: NSStatusItem
    var statusButton: NSStatusBarButton? { statusItem.button }
    var onToggleIsland: (() -> Void)?

    init(rootView: AnyView) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // Usa un título o una imagen
            button.title = "⌘"
            button.target = self
            button.action = #selector(toggleIsland)
        }

        // (Opcional) si quisieras un popover con SwiftUI:
        // let popover = NSPopover()
        // popover.contentSize = NSSize(width: 200, height: 100)
        // popover.behavior = .transient
        // popover.contentViewController = NSHostingController(rootView: rootView)
    }

    @objc private func toggleIsland() {
        onToggleIsland?()
    }
}
