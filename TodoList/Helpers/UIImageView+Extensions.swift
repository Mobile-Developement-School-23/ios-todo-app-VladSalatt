//
//  UIImageView+Extensions.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 27.06.2023.
//

import UIKit

extension UIImageView {
    func setImageOrHide(_ image: UIImage?) {
        self.image = image
        isHidden = image == nil
    }
}
