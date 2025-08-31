//
//  NSView+ScreenView.swift
//  sypNotch
//
//  Created by Paula on 31/8/25.
//


//
//  NSView+ScreenFrame.swift
//  sypNotch
//

import AppKit

extension NSView {
    /// Frame del view en coordenadas de pantalla
    func frameOnScreen() -> NSRect? {
        guard let win = self.window else { return nil }
        let fInWindow = convert(bounds, to: nil)
        return win.convertToScreen(fInWindow)
    }
}
