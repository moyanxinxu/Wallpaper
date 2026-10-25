//
//  Provider.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//
import SwiftUI

enum WallpaperProviders: String, CaseIterable {
    case bing = "Bing"
}

protocol WallpaperProvider {
    func fetch() async throws -> [Wallpaper]
}

struct BingProvider: WallpaperProvider {

    func fetch() async throws -> [Wallpaper] {
        let (data, response) = try await URLSession.shared.data(
            from: WallpaperProviders.bing.apiUrl
        )

        guard let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode)
        else { throw URLError(.badServerResponse) }

        let result = try JSONDecoder().decode(
            BingWallpaperResponseSchema.self,
            from: data
        )

        return try result.images.map { image in
            guard
                URL(
                    string: image.url,
                    relativeTo: URL(string: "https://www.bing.com")
                )?.absoluteURL != nil
            else {
                throw URLError(.badURL)
            }
            return Wallpaper(url: "https://www.bing.com" + image.url)
        }
    }
}
