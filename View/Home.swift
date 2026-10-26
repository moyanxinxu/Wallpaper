//
//  Home.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()

                #if os(macOS)
                    Button(role: .destructive) {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Image(systemName: "power").foregroundStyle(.red)
                    }.buttonBorderShape(.circle)
                #endif
            }

//            CurrentWallpaperView()
            TodayWallpaperView()
        }
        .frame(minWidth: AppConfig.minWidth, minHeight: AppConfig.minHeight)
        .padding()
    }
}

#Preview {
    Home()
}
