//
//  DetailItemView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 20.06.2023.
//

import UIKit

protocol DetailItemViewDelegate: AnyObject {
    func importanceChanged(value: Int)
    func toggleChanged(isOn: Bool)
    func showDate()
}

final class DetailItemView: UIView {
    weak var delegate: DetailItemViewDelegate?

    private var selectedDate: Date?

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()

    private lazy var titlesStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body
        label.textColor = .Label.primary
        return label
    }()
    private lazy var subtitleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .footnote
        button.setTitleColor(.Color.blue, for: .normal)
        return button
    }()

    private lazy var importanceControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            UIImage.Priority.low as Any,
            "нет",
            UIImage.Priority.high as Any
        ])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isHidden = true
        return control
    }()

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isHidden = true
        return toggle
    }()

    init(style: Style, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        bindUI()
        commonInit(with: style)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func configure(with model: Model) {
        titleLabel.text = model.title
        subtitleButton.setTitle(model.subtitle, for: .normal)
        subtitleButton.isHidden = model.subtitle == nil
        importanceControl.selectedSegmentIndex = model.selectedIndex ?? 1
        toggle.isOn = model.selectedDate != nil
        selectedDate = model.selectedDate
    }

    func changeSubtitle(with text: String?) {
        subtitleButton.setTitle(text, for: .normal)
        subtitleButton.isHidden = text == nil
    }

    func getModel() -> Model {
        Model(
            title: titleLabel.text ?? "",
            subtitle: subtitleButton.currentTitle,
            selectedIndex: importanceControl.selectedSegmentIndex,
            selectedDate: selectedDate
        )
    }
}

extension DetailItemView {
    struct Model {
        let title: String
        let subtitle: String?
        let selectedIndex: Int?
        let selectedDate: Date?

        init(
            title: String,
            subtitle: String? = nil,
            selectedIndex: Int? = nil,
            selectedDate: Date? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.selectedIndex = selectedIndex
            self.selectedDate = selectedDate
        }
    }

    enum Style {
        case segmentedControl
        case toggle
    }
}

private extension DetailItemView {
    func commonInit(with style: Style) {
        switch style {
        case .segmentedControl:
            importanceControl.isHidden = false
            toggle.isHidden = true
        case .toggle:
            importanceControl.isHidden = true
            toggle.isHidden = false
        }
    }

    func bindUI() {
        toggle.addAction(toggleAction, for: .valueChanged)
        importanceControl.addAction(importanceAction, for: .valueChanged)
        subtitleButton.addAction(dateButtonTapped, for: .touchUpInside)
    }

    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubviews(
            contentStackView.addArrangedSubviews(
                titlesStackView.addArrangedSubviews(
                    titleLabel,
                    subtitleButton
                ),
                importanceControl,
                toggle
            )
        )
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            importanceControl.widthAnchor.constraint(equalToConstant: 150)
        ])

        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subtitleButton.setContentHuggingPriority(.required, for: .horizontal)
    }
}

private extension DetailItemView {
    var toggleAction: UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.toggleChanged(isOn: self.toggle.isOn)
        }
    }

    var importanceAction: UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.importanceChanged(value: self.importanceControl.selectedSegmentIndex)
        }
    }
    var dateButtonTapped: UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.showDate()
        }
    }
}
