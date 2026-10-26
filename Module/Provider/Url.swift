//
//  Url.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//
import SwiftUI

extension WallpaperProviders {
    var apiUrl: URL {
        switch self {
        case .bing:
            return URL(
                string:
                    "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=8&mkt=us&rs=1"
            )!
        }
    }
}
