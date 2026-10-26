//
//  WallpaperCarousel.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/26.
//
import SwiftUI

struct WallpaperCarousel: View {
    let wallpapers: [URL]

    var body: some View {
        //        ScrollView(.vertical, showsIndicators: false) {
        VStack {
            ForEach(wallpapers, id: \.self) { wallpaper in
                if let nsImage = NSImage(contentsOf: wallpaper) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: ViewConfig.cornerRadius
                            )
                        )
                        .contextMenu {
                            TodayWallpaperMenuView(shareUrl: wallpaper)
                        }
                }
            }
        }
        //        }
    }
}
