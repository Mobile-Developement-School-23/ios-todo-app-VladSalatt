//
//  TodoListView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoListViewDelegate: AnyObject {
    func presentDetail()
}

final class TodoListView: UIView {

    weak var delegate: TodoListViewDelegate?
    
    private lazy var tapMeButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("tap me", for: .normal)
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        tapMeButton.addAction(.init(handler: { [weak self] _ in
            self?.delegate?.presentDetail()
        }), for: .touchUpInside)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TodoListView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .Back.primary
        
        addSubviews(
            tapMeButton
        )
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tapMeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tapMeButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
