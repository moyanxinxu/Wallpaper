//
//  Config.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

enum AppConfig {
    static let name = "Wallpaper"
    static let documets = "Documents"
    static let downloadWallpaperTitle = "保存壁纸"
    static let area = "us"

    static let minHeight = 400.0
}

enum WallpaperConfig {
    //    static let width =
    static let cornerRadius = 6.0
}

enum FileFormatSuffix: String {
    case jpg = "jpg"
    case png = "png"
}
