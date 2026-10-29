//
//  Dir.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit

func getAppDateDirectory() -> URL {
    return URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(AppConfig.documets, isDirectory: true)
        .appendingPathComponent(AppConfig.name, isDirectory: true)
}

func getTodayDirectory() throws -> URL {
    let date = try getNowDate()
    let directory = getAppDateDirectory()

    return directory.appending(path: date, directoryHint: .isDirectory)
}

func createTodayDirectory() throws -> URL {
    let todayDirectory = try getTodayDirectory()
    try createDirectory(todayDirectory)

    return todayDirectory
}

/// 删除文件
func deleteFile(at url: URL) throws {
    let type = try getUrlType(at: url)

    if type != .typeRegular {
        throw AppError.invalidPathType
    }

    try FileManager.default.removeItem(at: url)
}

/// 查看文件或文件夹是否存在
func isFileExisted(at url: URL) throws -> Bool {
    let _ = false

    if try getUrlType(at: url) != .typeRegular {
        throw AppError.invalidPathType
    }

    return FileManager.default.fileExists(atPath: url.path())
}

/// 获取路径类型
func getUrlType(at url: URL) throws -> FileAttributeType {
    let items = try FileManager.default.attributesOfItem(atPath: url.path())

    guard let type = items[.type] as? FileAttributeType else {
        throw AppError.unableGetUrlType
    }

    return type
}

/// 在Finder选中某些文件
func hilightFilesInFinder(_ urls: [URL]) {
    let fileUrls = urls.map { url -> URL in
        if url.isFileURL {
            return url.standardizedFileURL
        } else {
            return URL(fileURLWithPath: url.path())
        }
    }

    NSWorkspace.shared.activateFileViewerSelecting(fileUrls)
}

func createDirectory(_ url: URL) throws {
    if !url.hasDirectoryPath {
        throw AppError.invalidPathType
    }

    do {
        try FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    } catch {
        throw AppError.unableCreateDirectory
    }
}

func getFiles(in url: URL) throws -> [URL] {
    let urls: [URL]

    do {
        urls = try FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil
        )

    } catch {
        throw AppError.unableGetFiles
    }

    return urls
}
