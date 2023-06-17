//
//  UIStackView+Extensions.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 20.06.2023.
//

import UIKit

extension UIView {
    
    @discardableResult
    func addSubviews(_ views: UIView...) -> UIView {
        views.forEach { addSubview($0) }
        return self
    }
}

extension UIStackView {
    
    @discardableResult
    func addArrangedSubviews(_ views: UIView...) -> UIView {
        views.forEach { addArrangedSubview($0) }
        return self
    }
}
