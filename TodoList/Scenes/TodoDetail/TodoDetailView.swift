//
//  TodoDetailView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoDetailViewDeletage: AnyObject {
    func save(_ model: TodoDetailView.OutputModel)
    func delete()
    func dismiss()
}

final class TodoDetailView: UIView {

    weak var delegate: TodoDetailViewDeletage?

    private lazy var navigaionBar = DetailNavigationBar()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .Back.primary
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private lazy var footerView = DetailFooterView()

    private lazy var textView = DetailTextView()

    private lazy var deleteButton = DetailDeleteButton()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        navigaionBar.delegate = self
        textView.delegate = self

        setupUI()
        bindUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Model) {
        textView.configure(with: model.text)
        footerView.configure(with: model.footer)
        
        let isEnabled = model.text?.isEmpty == false
        navigaionBar.setSaveButton(isEnabled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension TodoDetailView {
    struct Model {
        let text: DetailTextView.Model
        let footer: DetailFooterView.Model
    }
}

extension TodoDetailView.Model {
    static var `default`: Self {
        Self(
            text: "",
            footer: DetailFooterView.Model(
                importance: DetailItemView.Model(
                    title: "Важность",
                    selectedIndex: 1
                ),
                deadline: DetailItemView.Model(
                    title: "Сделать до"
                )
            )
        )
    }
}

private extension TodoDetailView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .Back.primary

        addSubviews(
            navigaionBar,
            scrollView.addSubviews(
                contentView.addSubviews(
                    contentStackView.addArrangedSubviews(
                        textView,
                        footerView,
                        deleteButton
                    )
                )
            )
        )

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            navigaionBar.topAnchor.constraint(equalTo: topAnchor),
            navigaionBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            navigaionBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navigaionBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        let scrollBottomContraint = scrollView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        scrollBottomContraint.isActive = true
        scrollBottomContraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    func bindUI() {
        deleteButton.addAction(deleteAction, for: .touchUpInside)
    }
}

private extension TodoDetailView {
    var deleteAction: UIAction {
        UIAction { [weak self] _ in
            self?.delegate?.delete()
        }
    }
}

extension TodoDetailView: DetailNavigationBarDelegate {
    func saveButtonTapped() {
        let footer = footerView.getModel()

        let model = OutputModel(
            text: textView.getModel() ?? "",
            importanceInt: footer.importance.selectedIndex ?? 1,
            deadLine: footer.deadline.selectedDate
        )

        delegate?.save(model)
    }

    func cancelButtonTapped() {
        delegate?.dismiss()
    }

    struct OutputModel {
        let text: String
        let importanceInt: Int
        let deadLine: Date?
    }
}

extension TodoDetailView: DetailTextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let isEnabled = !textView.text.isEmpty
        navigaionBar.setSaveButton(isEnabled)
    }
}
