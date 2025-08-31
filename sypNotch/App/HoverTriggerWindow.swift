//
//  HoverTriggerWindow.swift
//  sypNotch
//
//  Created by SYP on 31/8/25.
//

import AppKit

// MARK: - Ventana trigger de hover (no activa, transparente)
final class HoverTriggerWindow: NSPanel {
    var onHoverChange: ((Bool) -> Void)?
    private let getScreen: () -> NSScreen?
    private let getStatusButtonFrameOnScreen: () -> NSRect?

    private(set) var isMouseInside: Bool = false

    // Vista que gestiona el NSTrackingArea de forma sólida
    private let trackingView = TrackingView()

    init(
        getScreen: @escaping () -> NSScreen?,
        getStatusButtonFrameOnScreen: @escaping () -> NSRect?
    ) {
        self.getScreen = getScreen
        self.getStatusButtonFrameOnScreen = getStatusButtonFrameOnScreen

        super.init(
            contentRect: .init(x: 0, y: 0, width: 1, height: 1),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        // Config ventana
        level = .statusBar
        isOpaque = false
        backgroundColor = .clear
        hasShadow = false
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isMovableByWindowBackground = false
        hidesOnDeactivate = false
        worksWhenModal = true

        // No robar foco
        becomesKeyOnlyIfNeeded = false
        preventsApplicationTerminationWhenModal = false

        // Contenido: nuestra trackingView
        contentView = trackingView

        // Callbacks de la trackingView
        trackingView.onEnter = { [weak self] in
            guard let self = self else { return }
            self.isMouseInside = true
            self.onHoverChange?(true)
        }
        trackingView.onExit = { [weak self] in
            guard let self = self else { return }
            self.isMouseInside = false
            self.onHoverChange?(false)
        }
    }

    /// Muestra la ventana invisible pero capturando hover
    func show() {
        orderFrontRegardless()
        alphaValue = 0.01 // casi invisible, pero recibe eventos
        // (Para depurar, pon 0.25 y activa trackingView.debug = true)
    }

    /// Recalcula y centra el rect en el status item (cubre barra + banda inferior)
    func recenter() {
        guard let screen = getScreen(),
              let statusFrame = getStatusButtonFrameOnScreen() else { return }

        let menuBarH = NSStatusBar.system.thickness
        let hotW = NotchConfig.hotWidth
        let bandH = NotchConfig.hoverHeight

        let centerX = statusFrame.midX
        let x = centerX - hotW / 2

        // Cubre barra de menús + banda inferior (más tolerante al movimiento)
        let totalH = menuBarH + bandH
        let y = screen.frame.maxY - totalH

        setFrame(.init(x: x, y: y, width: hotW, height: totalH), display: true)
        orderFrontRegardless()
    }
}

// MARK: - NSView que mantiene el tracking area siempre correcto
private final class TrackingView: NSView {
    var onEnter: (() -> Void)?
    var onExit: (() -> Void)?

    // Pon a true para ver el área de hover durante test
    var debug: Bool = false {
        didSet { needsDisplay = true }
    }

    private var trackingArea: NSTrackingArea?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let ta = trackingArea { removeTrackingArea(ta) }

        let opts: NSTrackingArea.Options = [
            .mouseEnteredAndExited,
            .activeAlways,
            .inVisibleRect
        ]
        let ta = NSTrackingArea(rect: .zero, options: opts, owner: self, userInfo: nil)
        addTrackingArea(ta)
        trackingArea = ta
    }

    override func mouseEntered(with event: NSEvent) {
        onEnter?()
    }

    override func mouseExited(with event: NSEvent) {
        onExit?()
    }

    // Dibujo de depuración opcional
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard debug, let ctx = NSGraphicsContext.current?.cgContext else { return }
        ctx.setLineWidth(1)
        NSColor.systemRed.setStroke()
        ctx.stroke(bounds)
        NSColor.systemRed.withAlphaComponent(0.12).setFill()
        ctx.fill(bounds)
    }
}
