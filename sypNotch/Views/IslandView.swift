//
//  IslandView.swift
//  sypNotch
//
//  Created by Paula on 31/8/25.
//


import SwiftUI

struct IslandView: View {
    var body: some View {
        HStack(spacing: 12) {
            WidgetCard(title: "Música") { Text("Play / Next") }
            WidgetCard(title: "Hoy") { Text("Sin eventos") }
            WidgetCard(title: "Bandeja") { Text("Arrastra aquí") }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(.white.opacity(0.12)))
        .frame(width: 520, height: 220)
    }
}

struct WidgetCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline.bold())
            content.font(.caption)
            Spacer()
        }
        .padding(10)
        .frame(width: 160, height: 160)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

//#Preview {
//    IslandView()
//}
