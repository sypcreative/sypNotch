//
//  IslandView.swift
//  sypNotch
//
//  Created by Paula on 31/8/25.
//
//
//  IslandView.swift
//  sypNotch
//

import SwiftUI

struct IslandView: View {
    var body: some View {
        ZStack {
            // Fondo estilo material
            VisualEffectBlur(material: .menu, blendingMode: .behindWindow)
            VStack(spacing: 8) {
                Text("sypNotch")
                    .font(.system(size: 14, weight: .bold))
                Text("Island content here")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Helper para blur nativo
struct VisualEffectBlur: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
