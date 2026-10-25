//
//  Wallpaper.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit

///获取mac当前桌面壁纸
func getCurrentWallpaperUrl() throws -> URL? {
    guard let screen = NSScreen.main else {
        throw AppError.unableGetCurrentWallpaper
    }

    return NSWorkspace.shared.desktopImageURL(for: screen)
}

///依据URL设置当前桌面的壁纸
func setupWallpaperForTargetScreen(from url: URL) -> Bool {
    return true
}

func setupWallpaperForAllScreen(_ url: URL) throws {
    if !isFileExisted(at: url) {
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

func getTodayWallpaperUrl() throws -> URL {
    let time = try getNowDate()
    let dateDirectory = getAppDateDirectoryUrl()
    let fileUrl =
        dateDirectory
        .appendingPathComponent(time)
        .appendingPathExtension(FileFormatSuffix.jpg.rawValue)

    return fileUrl
}

func loadTodayWallpaperIfExisted() throws -> URL? {
    let fileUrl = try getTodayWallpaperUrl()

    guard isFileExisted(at: fileUrl) else { return nil }

    return fileUrl
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
