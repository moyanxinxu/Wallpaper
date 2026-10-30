//
//  TodayWallpaperView.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit
import SwiftUI
internal import UniformTypeIdentifiers

fileprivate enum ViewState {
    case waitNetwork
    case loading
    case success(url: URL, title: String)
    case failed(String)
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
            case .failed(_), .waitNetwork:
                ErrorView().padding(8)
            }
        }.task { await loadWallpaper() }
    }

    private func loadWallpaper() async {
        let lifecycle = Lifecycle<Void>(
            onError: { error in state = .failed(error.localizedDescription) },
            onSettled: { NetworkManager.shared.stopMonitoring() }
        )

        await lifecycle.invoke {

            let todayDirectory = try createTodayDirectory()

            if let wallpaperUrl = try getTodayWallpaperUrl() {
                let title =
                    wallpaperUrl
                    .deletingPathExtension()
                    .lastPathComponent
                state = .success(url: wallpaperUrl, title: title)
                return
            }

            guard NetworkManager.shared.isConnectedToWifi == true else {
                state = .waitNetwork
                return
            }

            guard let wallpaper = try await provider.fetch().first else {
                state = .failed("bad response from bing api")
                return
            }

            let target = todayDirectory.appendingPathComponent(
                wallpaper.title,
                conformingTo: .jpeg
            )

            await downloadWallpaper(from: wallpaper.url, target: target)
            state = .success(url: target, title: wallpaper.title)
        }
    }
}

#Preview {
    TodayWallpaperView()
}
