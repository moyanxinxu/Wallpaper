//
//  Time.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/24.
//

import Foundation

func getNowDate() throws -> String {
    let components = Calendar.current.dateComponents(
        [.year, .month, .day],
        from: Date()
    )

    guard
        let year = components.year,
        let month = components.month,
        let day = components.day
    else { throw AppError.unableGetDate }

    return String(format: "%4d-%02d-%02d", year, month, day)
}
