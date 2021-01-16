//
//  DateFormatter.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.01.21.
//

import UIKit

extension DateFormatter {
    static let standard: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
