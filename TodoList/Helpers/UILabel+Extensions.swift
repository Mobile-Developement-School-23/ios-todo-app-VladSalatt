//
//  UILabel+Extensions.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 27.06.2023.
//

import UIKit

extension UILabel {
    func setTextOrHide(_ text: String?) {
        self.text = text
        isHidden = text == nil
    }
}
