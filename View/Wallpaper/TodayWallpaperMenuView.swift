//
//  TodayWallpaperMenuView.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/25.
//

import SwiftUI

struct ShareWallpaperButton: View {
    let url: URL

    var body: some View {
        ShareLink(item: URL(fileURLWithPath: url.path())) {
            Label("分享", systemImage: "square.and.arrow.up")
        }
    }
}

struct SetupWallpaperButton: View {
    let url: URL

    var body: some View {
        Button {
            try? setupWallpaperForAllScreen(url)
        } label: {
            Label("为所有显示器设置当前壁纸", systemImage: "laptopcomputer")
        }
    }
}

struct ShowWallpaperInFinderButton: View {
    let urls: [URL]

    var body: some View {
        Button {
            hilightFilesInFinder(urls)
        } label: {
            Label("在Finder中显示", systemImage: "folder")
        }
    }
}

struct TodayWallpaperMenuView: View {
    let shareUrl: URL?

    var body: some View {
        VStack {
            if let shareUrl = shareUrl {
                ShareWallpaperButton(url: shareUrl)
                ShowWallpaperInFinderButton(urls: [shareUrl])
                SetupWallpaperButton(url: shareUrl)
            }

        }.labelStyle(.titleAndIcon)

    }
}
