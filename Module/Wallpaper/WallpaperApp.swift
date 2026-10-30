//
//  WallpaperApp.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit
import SwiftUI

@main
struct WallpaperApp: App {
    init() { NetworkManager.shared.startMonitoring() }
    
    var body: some Scene {
        MenuBarExtra(AppConfig.name, systemImage: "photo") { Home() }
            .menuBarExtraStyle(.window)
    }
}
