//
//  UIColor+Extensions.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 18.06.2023.
//

import UIKit

extension UIColor {
    struct Support {
        static var separator: UIColor? { UIColor(named: "Separator") }
        static var overlay: UIColor? { UIColor(named: "Overlay") }
        static var navBarBlur: UIColor? { UIColor(named: "NavBar Blur") }
    }
    struct Label {
        static var primary: UIColor? { UIColor(named: "Label Primary") }
        static var secondary: UIColor? { UIColor(named: "Label Secondary") }
        static var disable: UIColor? { UIColor(named: "Disable") }
        static var tertiary: UIColor? { UIColor(named: "Tertiary") }
    }
    struct Color {
        static var red: UIColor? { UIColor(named: "Red") }
        static var blue: UIColor? { UIColor(named: "Blue") }
        static var green: UIColor? { UIColor(named: "Green") }
        static var white: UIColor? { UIColor(named: "White") }
        static var gray: UIColor? { UIColor(named: "Gray") }
        static var grayLight: UIColor? { UIColor(named: "Gray Light") }
    }
    struct Back {
        static var iosPrimary: UIColor? { UIColor(named: "iOS Primary") }
        static var primary: UIColor? { UIColor(named: "Back Primary") }
        static var secondary: UIColor? { UIColor(named: "Back Secondary") }
        static var elevated: UIColor? { UIColor(named: "Elevated") }
    }
}

extension UIColor {
    /// Инит преобразующий HEX в объект UIColor
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF

        self.init(
            red: .init(red) / 255,
            green: .init(green) / 255,
            blue: .init(blue) / 255,
            alpha: alpha
        )
    }
}
