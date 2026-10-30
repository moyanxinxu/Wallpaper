//
//  TodayWallpaperView.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit
import SwiftUI
internal import UniformTypeIdentifiers

private enum ViewState {
    case waitNetwork
    case loading
    case success(url: URL, title: String)
    case failed
}

struct TodayWallpaperView: View {
    private let provider: BingProvider = BingProvider()

    @State private var state: ViewState = .loading

    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
            case .success(let url, let title):
                WallpaperCarousel(url: url, title: title)
            case .failed, .waitNetwork:
                VStack {
                    ErrorView()
                    HStack {
                        Button("退出", systemImage: "power") {
                            NSApplication.shared.terminate(nil)
                        }

                        Button("重试", systemImage: "goforward") {

                        }
                        .buttonStyle(.borderedProminent)
                    }
                }.padding(8)

            }
        }.task { await loadWallpaper() }
    }

    //MARK: 有壁纸缓存时的操作
    private func stepAtHavingWallpaperCache(_ url: URL) {
        state = .success(url: url, title: getFileName(url))
    }

    private func stepAtWifiIsReady(dir: URL) async throws {
        guard
            let wallpaper = try await provider.fetch().first
        else {
            state = .failed
            return
        }

        let title = wallpaper.title
        let target = dir.appendingPathComponent(title, conformingTo: .jpeg)

        try await downloadWallpaper(wallpaper.url, target: target)
        try Task.checkCancellation()

        state = .success(url: target, title: title)
    }

    private func loadWallpaper() async {
        let lifecycle = Lifecycle<Void>(
            onMutate: { state = .loading },
            onError: { _ in state = .failed }
        )

        await lifecycle.invoke {

            //MARK: 创建今日壁纸目录
            let todayDirectory = try createTodayDirectory()

            //MARK: 本地是否有壁纸缓存
            if let wallpaperUrl = try getTodayWallpaperUrl() {
                stepAtHavingWallpaperCache(wallpaperUrl)
                return
            }

            let wifiReady = await NetworkManager.shared.isWifiReady()
            try Task.checkCancellation()

            if !wifiReady {
                state = .waitNetwork
                return
            }

            try await stepAtWifiIsReady(dir: todayDirectory)
        }
    }
}

#Preview {
    TodayWallpaperView()
}
