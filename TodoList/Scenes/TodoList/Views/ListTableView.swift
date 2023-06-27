//
//  Test.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 29.06.2023.
//

import UIKit

final class ListTableView: UITableView {
    override var contentSize: CGSize {
        didSet { self.invalidateIntrinsicContentSize() }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        let maxHeight = UIScreen.main.bounds.size.height - 100
        let height = min(contentSize.height, maxHeight)
        isScrollEnabled = height < contentSize.height
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: height
        )
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = .Back.secondary
        layer.cornerRadius = 16
        showsVerticalScrollIndicator = false
        separatorInset = .init(top: 0, left: 52, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
