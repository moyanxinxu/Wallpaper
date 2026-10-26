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
        try workspace.setDesktopImageURL(
            URL(fileURLWithPath: url.path()),
            for: screen,
            options: [:]
        )
    }
}

func getWallpaperUrls(in Url: URL) throws -> [URL] {
    let files = try getFiles(in: Url)

    return files.filter { ImageFormat.contains($0.pathExtension.lowercased()) }
}

enum DownloadResult {
    case success(URL)
    case failure(Error)

}

/// 根据url下载壁纸
func downloadWallpaper(from url: URL, target: URL) async -> DownloadResult {

    //    let components = Calendar.current.dateComponents(
    //        [.year, .month, .day],
    //        from: Date()
    //    )
    //
    //    let pannel = NSSavePanel()
    //    pannel.title = AppConfig.downloadWallpaperTitle
    //    pannel.allowedContentTypes = [.jpeg]
    //    pannel.canCreateDirectories = true

    do {
        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse,
            !(200...299).contains(httpResponse.statusCode)
        {
            throw URLError(.badServerResponse)
        }

        guard let image = NSImage(data: data),
            image.isValid
        else {
            throw URLError(.cannotDecodeContentData)
        }

        try data.write(to: target, options: .atomic)
        return .success(target)
    } catch {
        return .failure(error)
    }
}
