//
//  APIError.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/28.
//
import Foundation

enum APIError: Error {
    case invalidUrl
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
    case badResponse
}
