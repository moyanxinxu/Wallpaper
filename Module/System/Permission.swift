//
//  Permission.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/11/1.
//

enum PermissionApplicant: String {
    case notification

    var string: String {
        switch self {
        case .notification: "notificaton"
        }
    }
}

enum PermissionStatus {
    case authorized, denied, notDetermined, restricted
}

///权限控制协议
protocol Permission {
    func status() async -> PermissionStatus
    @discardableResult
    func requirePermission() async throws -> PermissionStatus
    func openSetting()
}

@MainActor
final class PermissionManager {
    static let shared = PermissionManager()

    private var permissions: [String: any Permission] = [:]

    //注册权限项目
    func register(_ key: PermissionApplicant, permission: any Permission) {
        permissions[key.string] = permission
    }

    //获取权限状态
    func check(_ key: PermissionApplicant) async -> PermissionStatus? {
        return await permissions[key.string]?.status()
    }

    //申请权限
    @discardableResult
    func require(_ key: PermissionApplicant) async throws -> PermissionStatus? {
        return try await permissions[key.string]?.requirePermission()
    }

    //打开设置
    func openSettings(_ key: PermissionApplicant) {
        permissions[key.string]?.openSetting()
    }

    //申请注册表内所有权限
    func requireAllPermissions() async {
        for permission in permissions.values {
            if await permission.status() == .notDetermined {
                _ = try? await permission.requirePermission()
            }
        }
    }
}

func RequirePermissions() async {
    PermissionManager.shared
        .register(
            PermissionApplicant.notification,
            permission: NotificationManager.shared
        )

    await PermissionManager.shared.requireAllPermissions()
}
