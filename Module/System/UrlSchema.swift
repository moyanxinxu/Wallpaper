//
//  UrlSchema.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/11/1.
//

import Foundation

enum UrlSchema {
    case notification

    var url: URL {
        switch self {
        case .notification:
            URL(
                string:
                    "x-apple.systempreferences:com.apple.Notifications-Settings.extension"
            )!
        }
    }
}
