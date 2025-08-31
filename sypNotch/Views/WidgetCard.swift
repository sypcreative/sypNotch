//
//  WidgetCard.swift
//  sypNotch
//
//  Created by Paula on 31/8/25.
//


import SwiftUI

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
