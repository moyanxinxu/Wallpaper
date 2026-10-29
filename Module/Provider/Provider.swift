//
//  Provider.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//
import SwiftUI

enum WallpaperProviders: String, CaseIterable {
    case bing = "Bing"
}

protocol WallpaperProvider {
    func fetch() async throws -> [Wallpaper]
}

struct BingProvider: WallpaperProvider {
    let host = WallpaperProviders.bing.host

    func fetch() async throws -> [Wallpaper] {
        let data = try await ApiRequest(WallpaperProviders.bing.apiUrl)
            .query("format", value: "js")
            .query("idx", value: "0")
            .query("n", value: "1")
            .query("mkt", value: "zh-CN")
            .getJson(BingWallpaperResponseSchema.self)
            .images

        return data.map { img in
            Wallpaper(url: host + img.urlbase + "_UHD.jpg", title: img.title)
        }
    }
}
