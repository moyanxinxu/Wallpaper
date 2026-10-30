//
//  Wallpaper.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit

let ImageFormat = ["jpg", "jpeg", "png"]

///获取mac当前桌面壁纸
func getCurrentWallpaperUrl() throws -> URL? {
    guard let screen = NSScreen.main else {
        throw AppError.unableGetCurrentWallpaper
    }

    return NSWorkspace.shared.desktopImageURL(for: screen)
}

func setupWallpaperForAllScreen(_ url: URL) throws {
    guard try isFileExisted(at: url) else {
        throw AppError.unableGetTodayWallpaper
    }

    let workspace = NSWorkspace.shared
    for screen in NSScreen.screens {
        try workspace.setDesktopImageURL(url, for: screen)
    }
}

func getTodayWallpaperUrl() throws -> URL? {
    let todayDiectory = try getTodayDirectory()
    let files = try getFiles(in: todayDiectory)

    guard
        let todayWallpaperUrl = files.first(
            where: { ImageFormat.contains($0.pathExtension.lowercased()) })
    else {
        return nil
    }

    return todayWallpaperUrl
}

func downloadWallpaper(_ url: String, target: URL) async throws {
    let data = try await ApiRequest(url).getDate()

    guard let image = NSImage(data: data), image.isValid else {
        throw URLError(.cannotDecodeContentData)
    }

    try data.write(to: target, options: .atomic)
}
