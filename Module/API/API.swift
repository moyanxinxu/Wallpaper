//
//  API.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/28.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class ApiRequest {
    private let url: URL
    private var method: HTTPMethod = .get
    private var headers: [String: String] = [:]
    private var queries: [URLQueryItem] = []

    init(_ url: String) { self.url = URL(string: url)! }

    @discardableResult
    func method(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    @discardableResult
    func header(_ key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }

    @discardableResult
    func query(_ name: String, value: String) -> Self {
        self.queries.append(URLQueryItem(name: name, value: value))
        return self
    }

    private func request() async throws -> Data {
        guard
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
        else {
            throw APIError.invalidUrl
        }

        if !queries.isEmpty {
            components.queryItems = (components.queryItems ?? []) + queries
        }

        guard let requestUrl = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(response.statusCode) else {
            throw
                APIError.httpError(statusCode: response.statusCode, data: data)
        }

        return data
    }

    func getJson<T: Decodable>(_ type: T.Type) async throws -> T {
        let data = try await request()
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func getDate() async throws -> Data {
        return try await request()
    }
}
