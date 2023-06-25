//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

final class TodoDetailViewController: UIViewController {

    // MARK: - Properties

    var presenter: TodoDetailPresenterProtocol?
    private lazy var customView = TodoDetailView()

    // MARK: - UIViewController Events

    override func viewDidLoad() {
        super.viewDidLoad()
        customView.delegate = self
        setupUI()
        customView.configure(with: presenter?.makeModel())
    }
}

private extension TodoDetailViewController {
    func setupUI() {
        view.addSubview(customView)

        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - TodoDetailPresenter Delegate

extension TodoDetailViewController: TodoDetailViewDeletage {
    func save(_ model: TodoDetailView.OutputModel) {
        let item = TodoItem(from: model)
        presenter?.save(item)
    }

    func dismiss() {
        dismiss(animated: true)
    }
}

extension TodoDetailViewController: TodoDetailViewProtocol {
}

private extension TodoItem {
    init(from model: TodoDetailView.OutputModel) {
        self.init(
            text: model.text,
            importance: Importance(from: model.importanceInt),
            deadline: model.deadLine,
            isDone: false,
            createdAt: Date(),
            changedAt: nil
        )
    }
}

private extension TodoItem.Importance {
    init(from index: Int) {
        switch index {
        case 0:
            self = .low
        case 1:
            self = .basic
        case 2:
            self = .important
        default:
            self = .basic
        }
    }
}
