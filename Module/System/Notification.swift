//
//  Notification.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/11/1.
//

import AppKit
import UserNotifications

@MainActor
final class NotificationManager: Permission {

    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()

    func status() async -> PermissionStatus {
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        @unknown default:
            return .restricted
        }
    }

    func requirePermission() async throws -> PermissionStatus {
        if try await center.requestAuthorization() {
            return .authorized
        }

        return .denied
    }

    func openSetting() {
        NSWorkspace.shared.open(UrlSchema.notification.url)
    }
}

extension NotificationManager {
    func send(title: String, body: String) async throws {
        if !(await status() == .authorized) {
            try await PermissionManager.shared.require(.notification)
        }

        let content = UNMutableNotificationContent()

        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        try? await center.add(request)
    }
}
