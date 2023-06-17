//
//  DetailTextView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 22.06.2023.
//

import UIKit

final class DetailTextView: UIView {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .Back.secondary
        textView.font = .body
        textView.textColor = .Label.primary
        textView.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    func configure(with model: Model) {
        textView.text = model
    }
    
    func getModel() -> Model {
        textView.text
    }
}

extension DetailTextView {
    typealias Model = String?
}

private extension DetailTextView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 16
        
        addSubviews(
            textView
        )
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
