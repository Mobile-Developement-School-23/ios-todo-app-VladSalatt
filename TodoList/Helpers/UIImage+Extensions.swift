//
//  UIImage+Extensions.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 20.06.2023.
//

import UIKit

extension UIImage {
    struct Priority {
        static var low: UIImage? { UIImage(named: "ic_priority_low") }
        static var high: UIImage? { UIImage(named: "ic_priority_high") }
    }
}
