//
//  ListTableHeaderView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 29.06.2023.
//

import UIKit

final class ListTableHeaderView: UIView {
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .Label.tertiary
        label.font = .subhead
        label.text = Strings.List.hadDone
        return label
    }()
    
    private var buttonState: ButtonState = .show {
        didSet {
            updateUI()
        }
    }
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.Color.blue, for: .normal)
        button.setTitle(Strings.List.show, for: .normal)
        button.titleLabel?.font = .subhead
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Model) {
        titleLabel.text = Strings.List.hadDone + String(model.successfulItems)
        buttonState = model.buttonState
    }
    
    func changeButton(_ state: ButtonState) {
        buttonState = state
    }
}

extension ListTableHeaderView {
    struct Model {
        let successfulItems: Int
        let buttonState: ButtonState
    }
    
    enum ButtonState {
        case show
        case hide
    }
}

private extension ListTableHeaderView.ButtonState {
    var title: String {
        switch self {
        case .show:
            return Strings.List.show
        case .hide:
            return Strings.List.hide
        }
    }
}

private extension ListTableHeaderView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(
            contentStackView.addArrangedSubviews(
                titleLabel,
                actionButton
            )
        )
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func updateUI() {
        actionButton.setTitle(buttonState.title, for: .normal)
    }
}
