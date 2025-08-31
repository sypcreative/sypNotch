//
//  sypNotchApp.swift
//  sypNotch
//
//  Created by SYP on 31/8/25.
//

import SwiftUI

@main
struct sypNotchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene { Settings { EmptyView() } } // sin ventana principal
}
