//
//  Error.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/24.
//

enum AppError: Error {
    case unableGetDate
    case unableGetAppDateDirectory
    case unableGetUrlType
    case invalidPathType
    case unableGetCurrentWallpaper
    case unableGetTodayWallpaper
    case unableCreateDirectory
    case unableGetFiles
    
    case internalError
}
