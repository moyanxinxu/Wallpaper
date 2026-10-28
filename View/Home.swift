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
                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Image(systemName: "power")
                            .foregroundStyle(.white)
                            .frame(
                                width: ViewConfig.stopAppButtonSize,
                                height: ViewConfig.stopAppButtonSize
                            )
                            .background(.blue, in: Circle())
                    }
                    .buttonStyle(.plain)
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
