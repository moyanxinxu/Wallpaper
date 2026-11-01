//
//  Toast.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/11/1.
//

import SwiftUI

enum ToastStatus {
    case normal, success, failed, loading, warning

    var icon: Image {
        switch self {
        case .normal: Image(systemName: "info")
        case .success: Image(systemName: "checkmark")
        case .failed: Image(systemName: "xmark")
        case .loading: Image(systemName: "arrow.trianglehead.clockwise")
        case .warning: Image(systemName: "exclamationmark.triangle")
        }
    }

    var color: Color {
        switch self {
        case .normal: .secondary
        case .success: .green
        case .failed: .red
        case .loading: .blue
        case .warning: .orange
        }
    }
}

struct Toast: View {
    let title: String?
    let desc: String?
    let status: ToastStatus

    var body: some View {
        VStack {
            //第一行
            HStack {
                if let title { Text(title).font(.headline) }
                Spacer()
                status.icon.foregroundStyle(status.color)
            }

            if let desc { Text(desc).font(.footnote) }
        }
        .padding(14)
        .background(.regularMaterial)
        .shadow(radius: 8)
    }
}

#Preview {
    Toast(title: "哈哈", desc: "1", status: .normal)
}
