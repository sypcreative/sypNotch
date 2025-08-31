//
//  NSStatusBarButton+ScreenFrame.swift
//  sypNotch
//
//  Created by Paula on 31/8/25.
//

import AppKit

extension NSStatusBarButton {
    /// Devuelve el frame del botón en coordenadas de **pantalla**.
    func frameOnScreen() -> NSRect? {
        guard let win = self.window else { return nil }
        // bounds -> coords de ventana
        let frameInWindow = self.convert(self.bounds, to: nil)
        // ventana -> pantalla
        return win.convertToScreen(frameInWindow)
    }
}

