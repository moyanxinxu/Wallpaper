//
//  File.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/26.
//

import Foundation

enum FileFormatSuffix: String {
    case jpg = "jpg"
    case jpeg = "jpeg"
    case png = "png"
}

func getFileName(_ url: URL, deletingPathExtension: Bool = true) -> String {
    var fileName = url

    if deletingPathExtension {
        fileName = url.deletingPathExtension()
    }

    return fileName.lastPathComponent
}
