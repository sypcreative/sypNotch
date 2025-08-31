    //
//  IslandWindowController.swift
//  sypNotch
//
//  Created by Paula on 31/8/25.
//

import AppKit
import SwiftUI

final class IslandWindowController: NSWindowController {

    private var hosting: NSHostingView<AnyView>?
    private let screen: NSScreen

    // Ajusta a tu gusto
    private let targetWidth: CGFloat = NotchConfig.islandWidth
    private let targetHeight: CGFloat = NotchConfig.islandHeight
    private let cornerRadius: CGFloat = NotchConfig.islandCornerRadius

    init<V: View>(rootView: V, on screen: NSScreen?) {
        self.screen = screen ?? NSScreen.main!
        let content = NSHostingView(rootView: AnyView(rootView))
        self.hosting = content

        let style: NSWindow.StyleMask = [.borderless]
        let w = NSWindow(contentRect: .zero, styleMask: style, backing: .buffered, defer: false, screen: self.screen)
        w.isOpaque = false
        w.backgroundColor = .clear
        w.level = .statusBar
        w.hasShadow = true
        w.ignoresMouseEvents = false
        w.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        w.titleVisibility = .hidden
        w.titlebarAppearsTransparent = true
        w.isMovableByWindowBackground = false

        // Contenedor con esquinas redondeadas
        let container = NSView()
        container.wantsLayer = true
        container.layer?.cornerRadius = cornerRadius
        container.layer?.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false

        if let hosting = self.hosting {
            hosting.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(hosting)
            NSLayoutConstraint.activate([
                hosting.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                hosting.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                hosting.topAnchor.constraint(equalTo: container.topAnchor),
                hosting.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            ])
        }

        w.contentView = container

        super.init(window: w)

        // Estado inicial: altura 0 pegada al borde superior
        setFrame(height: 0, width: targetWidth, animated: false)
        w.orderFrontRegardless()
        w.alphaValue = 0 // arranca invisible
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // Mantiene el TOP anclado a la parte superior de la pantalla
    private func setFrame(height h: CGFloat, width w: CGFloat, animated: Bool) {
        let scr = screen.frame
        let topY = scr.maxY
        let x = scr.midX - w/2 // centrado; puedes cambiarlo
        let y = topY - h       // top fijo

        let newFrame = NSRect(x: x, y: y, width: w, height: h)

        if animated {
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                ctx.duration = 0.18
                self.window?.animator().setFrame(newFrame, display: true)
            }
        } else {
            window?.setFrame(newFrame, display: true)
        }
    }

    // Variante centrada sobre el status button
    private func setFrameOverStatusButton(height h: CGFloat, width w: CGFloat, animated: Bool, statusFrame: NSRect) {
        let topY = screen.frame.maxY
        let x = statusFrame.midX - w/2
        let y = topY - h
        let rect = NSRect(x: x, y: y, width: w, height: h)
        if animated {
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                ctx.duration = 0.18
                window?.animator().setFrame(rect, display: true)
            }
        } else {
            window?.setFrame(rect, display: true)
        }
    }

    // Public: abrir/peek (opcionalmente alineado al status button)
    func showPeek(statusFrame: NSRect? = nil) {
        guard let win = window else { return }
        if win.alphaValue < 1 { win.alphaValue = 1 }
        if let sf = statusFrame {
            setFrameOverStatusButton(height: targetHeight, width: targetWidth, animated: true, statusFrame: sf)
        } else {
            setFrame(height: targetHeight, width: targetWidth, animated: true)
        }
    }

    func hidePeek() {
        setFrame(height: 0, width: targetWidth, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.window?.alphaValue = 0.0
        }
    }

    func toggle() {
        guard let win = window else { return }
        if win.alphaValue == 0 || win.frame.height == 0 {
            showPeek()
        } else {
            hidePeek()
        }
    }
}
