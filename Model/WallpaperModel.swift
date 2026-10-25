//
//  Wallpaper.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import Foundation

struct Wallpaper: Identifiable, Decodable {
    let id: String
    //    let title: String
    let url: String

    init(id: String = UUID().uuidString, url: String) {
        self.id = id
        //        self.title = title
        self.url = url
    }

    var nsUrl: URL? {
        return URL(string: url)
    }
}

///bing官方接口返回的数据类型结构
struct BingWallpaperSchema: Decodable {
    //    let startdate: String
    //    let fullstartdate: String
    //    let enddate: String
    let url: String
    let urlbase: String
    //    let copyright: String
    //    let copyrightlink:String
    //    let title: String
    //    let quiz: String
    //    let wp: Bool
    //    let hsh: String
    //    let drk: Int
    //    let top: Int
    //    let bot: Int
    //    let hs: [String]
}

/// bing官方接口返回的部分消息体
struct BingWallpaperResponseSchema: Decodable {
    let images: [BingWallpaperSchema]
}
