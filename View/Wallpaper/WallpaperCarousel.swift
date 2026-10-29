//
//  WallpaperCarousel.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/26.
//

import AppKit
import SwiftUI

struct WallpaperCarousel: View {
    let url: URL
    let title: String

    @State private var hovering = false

    private func wallpaperButtonGroup() -> some View {
        VStack {
            HStack {
                Text(title).foregroundStyle(.primary)
                
                Spacer()
                
                #if os(macOS)
                    Button("退出", systemImage: "power") {
                        NSApplication.shared.terminate(nil)
                    }
                    .labelStyle(.iconOnly)
                    .clipShape(.circle)
                    .opacity(hovering ? 1 : 0)
                    .offset(y: hovering ? 6 : 0)
                    .animation(.easeInOut(duration: 0.2), value: hovering)
                #endif
            }.frame(maxWidth: .infinity)

            Spacer()

            HStack {
                Button("应用壁纸", systemImage: "laptopcomputer") {
                    try? setupWallpaperForAllScreen(url)
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                ControlGroup {
                    Button("在Finder中显示", systemImage: "folder") {
                        hilightFilesInFinder([url])
                    }

                    ShareLink(item: url.path()) {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                }
                .fixedSize()
            }
            .opacity(hovering ? 1 : 0)
            .offset(y: hovering ? 0 : 6)
            .animation(.easeInOut(duration: 0.2), value: hovering)
        }
    }

    var body: some View {
        if let nsImage = NSImage(contentsOf: url) {
            Image(nsImage: nsImage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay { wallpaperButtonGroup().padding(8) }
                .onHover { isHovering in hovering = isHovering }
        }
    }
}
