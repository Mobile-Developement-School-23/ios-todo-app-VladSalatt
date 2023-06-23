//
//  DateFormatter+Extensions.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 23.06.2023.
//

import UIKit

extension DateFormatter {
    static let dayWithMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU_POSIX")
        formatter.dateFormat = "dd\u{00a0}MMMM"
        return formatter
    }()
}
