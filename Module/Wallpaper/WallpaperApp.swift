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
    var body: some Scene {
        MenuBarExtra("wallpaper", systemImage: "photo") {
            Home()
        }.menuBarExtraStyle(.window)
    }
}
