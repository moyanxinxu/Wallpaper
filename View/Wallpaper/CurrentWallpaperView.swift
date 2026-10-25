//
//  CurrentWallpaperView.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

//import AppKit
import SwiftUI

struct CurrentWallpaperView: View {
    @State private var wallpaperUrl: URL?

    var body: some View {
        VStack {
            Text("当前壁纸")
                .frame(maxWidth: .infinity, alignment: .leading)

            if let url = wallpaperUrl, let nsImage = NSImage(contentsOf: url) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: WallpaperConfig.cornerRadius
                        )
                    )
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            hookBeforeAppear()
        }
    }

    private func hookBeforeAppear() {
        guard let url = try? getCurrentWallpaperUrl() else { return }
        wallpaperUrl = url
    }
}
