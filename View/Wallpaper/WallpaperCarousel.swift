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

                Button("退出", systemImage: "power") {
                    NSApplication.shared.terminate(nil)
                }
                .labelStyle(.iconOnly)
                .clipShape(.circle)
                .opacity(hovering ? 1 : 0)
                .offset(y: hovering ? 6 : 0)
                .animation(.easeInOut(duration: 0.2), value: hovering)

            }.frame(maxWidth: .infinity)

            Spacer()

            HStack {
                Button("应用壁纸", systemImage: "laptopcomputer") {
                    try? setupWallpaperForAllScreen(url)
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                Menu {
                    Button {
                        hilightFilesInFinder([url])
                    } label: {
                        Label("在 Finder 中显示", systemImage: "folder")
                    }

                    ShareLink(item: url) {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .clipShape(.circle)
                .menuIndicator(.hidden)
                .labelStyle(.titleAndIcon)
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
