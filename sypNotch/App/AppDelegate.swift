//
//  AppDelegate.swift
//  sypNotch
//
//  Created by SYP on 31/8/25.
//

import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBar: MenuBarController!
    private var island: IslandWindowController!
    private var hoverWindow: HoverTriggerWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 1) Status item
        menuBar = MenuBarController(rootView: AnyView(Text("sypNotch")))
        menuBar.onToggleIsland = { [weak self] in self?.island.toggle() }

        // 2) Island (crece desde el borde superior de la pantalla)
        let barScreen = menuBar.statusButton?.window?.screen
        island = IslandWindowController(rootView: IslandView(), on: barScreen)

        // 3) Hover trigger window centrada en el status item
        hoverWindow = HoverTriggerWindow(
            getScreen: { [weak self] in self?.menuBar.statusButton?.window?.screen },
            getStatusButtonFrameOnScreen: { [weak self] in self?.menuBar.statusButton?.frameOnScreen() }
        )

        // 4) Reacción a hover (con pequeño debounce al salir)
        hoverWindow.onHoverChange = { [weak self] inside in
            guard let self = self else { return }
            if inside {
                let sf = self.menuBar.statusButton?.frameOnScreen()
                self.island.showPeek(statusFrame: sf)
            } else {
                // Evita flicker si el ratón reentra enseguida
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
                    guard let self = self else { return }
                    if self.hoverWindow.isMouseInside == true {
                        // sigue dentro: no cierres
                    } else {
                        self.island.hidePeek()
                    }
                }
            }
        }

        // 5) Mostrar y centrar el trigger
        hoverWindow.show()
        hoverWindow.recenter()

        // 6) Reposicionar si cambian pantallas
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.hoverWindow.recenter()
        }
    }
}
