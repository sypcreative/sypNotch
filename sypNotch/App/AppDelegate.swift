//
//  appDelegate.swift
//  sypNotch
//
//  Created by SYP on 31/8/25.
//

import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBar: MenuBarController!
    private var island: IslandWindowController!
    private var hoverTrigger: HoverTriggerWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBar = MenuBarController(rootView: AnyView(Text("sypNotch")))
        menuBar.onToggleIsland = { [weak self] in self?.island.toggle() }

        island = IslandWindowController(rootView: IslandView())

        hoverTrigger = HoverTriggerWindow(width: 520) // igual al ancho de la isla
        hoverTrigger.onHoverChange = { [weak self] inside in
            if inside { self?.island.show() } else { self?.island.hideDelayed() }
        }
    }
}

