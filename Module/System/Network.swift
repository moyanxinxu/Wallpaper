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

    private let queue = DispatchQueue(label: "com.apple.network.monitor")
    private var monitor: NWPathMonitor?
    private var wifiStatus: Bool?

    private init() {}

    var isConnectedToWifi: Bool? {
        queue.sync { wifiStatus }
    }

    func startMonitoring() {
        queue.async {
            guard self.monitor == nil else { return }

            let monitor = NWPathMonitor()
            self.monitor = monitor

            monitor.pathUpdateHandler = { [weak self, weak monitor] path in
                guard let self, let monitor, self.monitor === monitor else {
                    return
                }

                self.wifiStatus =
                    path.status == .satisfied && path.usesInterfaceType(.wifi)
            }

            monitor.start(queue: self.queue)
        }
    }

    func stopMonitoring() {
        queue.async {
            self.monitor?.cancel()
            self.monitor = nil
        }
    }
}
