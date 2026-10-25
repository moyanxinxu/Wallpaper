//
//  TodayWallpaperView.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit
import SwiftUI

private enum ViewState {
    case loading
    case success(Wallpaper)
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
            case .success(let wallpaper):
                if let nsImage = NSImage(
                    contentsOf: URL(fileURLWithPath: wallpaper.url)
                ) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: WallpaperConfig.cornerRadius
                            )
                        ).contextMenu {
                            TodayWallpaperMenuView(shareUrl: wallpaper.nsUrl)
                        }
                }


            case .failed(_):
                Image(systemName: "exclamationmark.triangle")
            }

        }.task { await loadWallpapers() }
    }

    private func loadWallpapers() async {
        do {
            let wallpaperCacheUrl = try getTodayWallpaperUrl()

            if isFileExisted(at: wallpaperCacheUrl) {
                let wallpaper = Wallpaper(url: wallpaperCacheUrl.path())
                state = .success(wallpaper)
                return
            }

            let wallpapers = try await provider.fetch()

            guard let wallpaper = wallpapers.first,
                let downloadUrl = URL(string: wallpaper.url)
            else { throw AppError.unableGetDate }

            _ = await downloadWallpaper(
                from: downloadUrl,
                target: wallpaperCacheUrl
            )

            let localWallpaperUrl = Wallpaper(url: wallpaperCacheUrl.path())

            state = .success(localWallpaperUrl)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
