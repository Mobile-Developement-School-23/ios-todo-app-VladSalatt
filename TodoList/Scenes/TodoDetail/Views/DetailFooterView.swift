//
//  DetailFooterView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 22.06.2023.
//

import UIKit

protocol DetailFooterViewDelegate: AnyObject {
//    func dateChanged(_ date: Date)
}

final class DetailFooterView: UIView {

    weak var delegate: DetailFooterViewDelegate?

    private(set) var model: Model?

    private lazy var contentStackView: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()

    private lazy var importanceView = DetailItemView(style: .segmentedControl)

    private lazy var deadlineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var firstDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .Support.separator
        return view
    }()

    private lazy var deadlineView = DetailItemView(style: .toggle)

    private lazy var datePickerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var secondDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .Support.separator
        view.isHidden = true
        return view
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        picker.isHidden = true
        return picker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        importanceView.delegate = self
        deadlineView.delegate = self
        setupUI()
        bindUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func configure(with model: Model) {
        importanceView.configure(with: model.importance)
        deadlineView.configure(with: model.deadline)
        guard let selectedDate = model.deadline.selectedDate else { return }
        datePicker.setDate(selectedDate, animated: false)
    }

    func getModel() -> Model {
        let importance = importanceView.getModel()
        let deadline = deadlineView.getModel()

        return Model(
            importance: DetailItemView.Model(
                title: importance.title,
                subtitle: importance.subtitle,
                selectedIndex: importance.selectedIndex,
                selectedDate: importance.selectedDate
            ),
            deadline: DetailItemView.Model(
                title: deadline.title,
                subtitle: deadline.subtitle,
                selectedIndex: deadline.selectedIndex,
                selectedDate: deadline.selectedDate
            )
        )
    }
}

extension DetailFooterView {
    struct Model {
        let importance: DetailItemView.Model
        let deadline: DetailItemView.Model
    }
}

extension DetailFooterView.Model {
    static var `default` = Self(
        importance: DetailItemView.Model(
            title: "Важность",
            selectedIndex: 1
        ),
        deadline: DetailItemView.Model(
            title: "Сделать до"
        )
    )
}

private extension DetailFooterView {
    func bindUI() {
        datePicker.addAction(datePickerTap, for: .valueChanged)
    }

    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 16
        backgroundColor = .Back.secondary

        addSubviews(
            contentStackView.addArrangedSubviews(
                importanceView,
                deadlineContainerView.addSubviews(
                    firstDivider,
                    deadlineView
                ),
                datePickerContainerView.addSubviews(
                    secondDivider,
                    datePicker
                )
            )
        )

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            firstDivider.heightAnchor.constraint(equalToConstant: 0.5),
            firstDivider.topAnchor.constraint(equalTo: deadlineContainerView.topAnchor),
            firstDivider.leadingAnchor.constraint(equalTo: deadlineContainerView.leadingAnchor, constant: 16),
            firstDivider.trailingAnchor.constraint(equalTo: deadlineContainerView.trailingAnchor, constant: -16)

        ])

        NSLayoutConstraint.activate([
            deadlineView.topAnchor.constraint(equalTo: deadlineContainerView.topAnchor),
            deadlineView.bottomAnchor.constraint(equalTo: deadlineContainerView.bottomAnchor),
            deadlineView.leadingAnchor.constraint(equalTo: deadlineContainerView.leadingAnchor),
            deadlineView.trailingAnchor.constraint(equalTo: deadlineContainerView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            secondDivider.heightAnchor.constraint(equalToConstant: 0.5),
            secondDivider.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
            secondDivider.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor, constant: 16),
            secondDivider.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor, constant: 8),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor, constant: -12),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor, constant: -10)
        ])
    }

    func showDatePicker() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self else { return }
                self.datePickerContainerView.isHidden = false
                self.secondDivider.isHidden = false
                self.datePicker.isHidden = false
            },
            completion: { [weak self] finished in
                guard let self, finished else { return }
                self.layoutIfNeeded()
            }
        )
    }

    func hideDatePicker() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self else { return }
                self.datePickerContainerView.isHidden = true
                self.secondDivider.isHidden = true
                self.datePicker.isHidden = true
            },
            completion: { [weak self] finished in
                guard let self, finished else { return }
                self.layoutIfNeeded()
            }
        )
    }
}

extension DetailFooterView: DetailItemViewDelegate {
    func importanceChanged(value: Int) {
        // Save importance to presenter
    }

    func toggleChanged(isOn: Bool) {
        defer { deadlineView.changeSubtitle(with: nil) }

        guard isOn else {
            hideDatePicker()
            return
        }
        showDatePicker()
    }

    func showDate() {
        showDatePicker()
    }
}

private extension DetailFooterView {
    var datePickerTap: UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            let date = self.datePicker.date
            self.deadlineView.changeSubtitle(with: date)
            self.hideDatePicker()
        }
    }
}
