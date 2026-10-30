//
//  ErrorView.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/30.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(
                    Color(.systemRed),
                    in: RoundedRectangle(cornerRadius: 8)
                )

            VStack(alignment: .leading) {
                Text("壁纸资源加载失败！").font(.headline)
                Text("未能从云端和本地获取到壁纸文件！").font(.footnote)
            }
        }

        Text("请确保网络通畅，或重新尝试获取！")
    }
}

#Preview {
    ErrorView()
}
