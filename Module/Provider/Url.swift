//
//  Url.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//
import SwiftUI

extension WallpaperProviders {
    var apiUrl: String {
        switch self {
        case .bing: "https://www.bing.com/HPImageArchive.aspx"
        }
    }

    var host: String {
        switch self {
        case .bing: "https://www.bing.com"
        }
    }
}
