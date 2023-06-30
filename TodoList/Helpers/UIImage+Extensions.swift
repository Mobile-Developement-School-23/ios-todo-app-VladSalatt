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

    struct RadioButton {
        static var gray: UIImage? { UIImage(named: "ic_radio_button_gray") }
        static var red: UIImage? { UIImage(named: "ic_radio_button_red") }
        static var green: UIImage? { UIImage(named: "ic_radio_button_green") }
        static var white: UIImage? { UIImage(named: "ic_radio_button_white") }
    }

    struct Visible {
        static var on: UIImage? { UIImage(named: "ic_visible_on") }
        static var off: UIImage? { UIImage(named: "ic_visible_off") }
    }
    
    static var chevronRight: UIImage? { UIImage(named: "ic_chevron") }
    static var plusButton: UIImage? { UIImage(named: "ic_plus_button") }
    static var calendar: UIImage? { UIImage(named: "ic_calendar") }
    static var whiteTrash: UIImage? { UIImage(named: "ic_white_trash") }
    static var whiteInfo: UIImage? { UIImage(named: "ic_info") }
}
