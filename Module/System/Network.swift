//
//  Network.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/30.
//

import Foundation
import Network

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func isWifiReady() async -> Bool {
        let monitor = NWPathMonitor(requiredInterfaceType: .wifi)

        defer { monitor.cancel() }

        for await path in monitor { return path.status == .satisfied }

        return false
    }
}
