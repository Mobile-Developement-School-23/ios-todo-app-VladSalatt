//
//  DetailNavigationBar.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 22.06.2023.
//

import UIKit

protocol DetailNavigationBarDelegate: AnyObject {
    func saveButtonTapped()
    func cancelButtonTapped()
}

final class DetailNavigationBar: UIView {

    weak var delegate: DetailNavigationBarDelegate?

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .body
        button.setTitleColor(.Color.blue, for: .normal)
        return button
    }()

    private lazy var leftStrenchableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Дело"
        label.font = .headline
        label.textColor = .Label.primary
        return label
    }()

    private lazy var rightStrenchableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .headline
        button.setTitleColor(.Color.blue, for: .normal)
        return button
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        bindUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailNavigationBar {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .Back.primary

        addSubviews(
            contentStackView.addArrangedSubviews(
                cancelButton,
                leftStrenchableView,
                titleLabel,
                rightStrenchableView,
                saveButton
            )
        )

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            leftStrenchableView.widthAnchor.constraint(equalTo: rightStrenchableView.widthAnchor)
        ])

        leftStrenchableView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightStrenchableView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    func bindUI() {
        saveButton.addAction(saveAction, for: .touchUpInside)
        cancelButton.addAction(cancelAction, for: .touchUpInside)
    }
}

private extension DetailNavigationBar {
    var saveAction: UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.saveButtonTapped()
        }
    }

    var cancelAction: UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.cancelButtonTapped()
        }
    }
}
