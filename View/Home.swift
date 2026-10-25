//
//  Home.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack{
            CurrentWallpaperView()
            TodayWallpaperView()
        }.padding()
    }
}

#Preview {
    Home()
}
