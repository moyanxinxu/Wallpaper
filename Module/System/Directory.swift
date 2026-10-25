//
//  Dir.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import AppKit

func getTempDirectoryUrl() -> URL {
    return FileManager.default.temporaryDirectory
}

//func getDocumentDirectoryUrl() -> URL {
//    return URL(string: NSHomeDirectory() + "/Documents")!
//}

func getAppDateDirectoryUrl() -> URL {
    return URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(AppConfig.documets, isDirectory: true)
        .appendingPathComponent(AppConfig.name, isDirectory: true)
}

func genTempUrlWithExtension(_ suffix: FileFormatSuffix) -> URL {
    let tempDir = getTempDirectoryUrl()
    return
        tempDir
        .appendingPathComponent(UUID().uuidString)
        .appendingPathExtension(suffix.rawValue)
}

/// 删除文件
func deleteFile(at url: URL) throws {
    let type = try getUrlType(at: url)

    if type != .typeRegular {
        throw AppError.invalidPathType
    }

    try FileManager.default.removeItem(at: url)
}

/// 判断文件路径是否存在
func isFileExisted(at url: URL) -> Bool {
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
        }
        return URL(fileURLWithPath: url.path())
    }
    
    NSWorkspace.shared.activateFileViewerSelecting(fileUrls)
}
