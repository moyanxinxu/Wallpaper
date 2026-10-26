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
    case loading
    case success([URL])
    case failed(String)
}

struct TodayWallpaperView: View {
    private let provider: BingProvider = BingProvider()

    @State private var state: ViewState = .loading

    var body: some View {
        VStack {
            Text("今日壁纸")
                .frame(maxWidth: .infinity, alignment: .leading)

            switch state {
            case .loading:
                ProgressView()
            case .success(let wallpapers):
                WallpaperCarousel(wallpapers: wallpapers)
            case .failed(_):
                Image(systemName: "exclamationmark.triangle")
            }

        }.task { await loadWallpapers() }
    }

    private func loadWallpapers() async {
        let lifecycle = Lifecycle<Void>(
            onMutate: { state = .loading },
            onError: { error in state = .failed(error.localizedDescription) }
        )

        await lifecycle.invoke {
            var wallpaperUrls: [URL]
            let todayDirectory = try getTodayDirectory()
            try createDirectory(todayDirectory)
            wallpaperUrls = try getWallpaperUrls(in: todayDirectory)

            if wallpaperUrls.isEmpty {
                let wallpapers = try await provider.fetch()

                await withTaskGroup(of: Void.self) { group in
                    for (idx, wallpaper) in wallpapers[0...1].enumerated() {
                        group.addTask {
                            let target = todayDirectory.appendingPathComponent(
                                "\(idx)",
                                conformingTo: .jpeg
                            )

                            _ = await downloadWallpaper(
                                from: URL(string: wallpaper.url)!,  //TODO
                                target: target
                            )
                        }
                    }
                }
            }

            wallpaperUrls = try getFiles(in: todayDirectory)
            state = .success(wallpaperUrls)
        }
    }
}
