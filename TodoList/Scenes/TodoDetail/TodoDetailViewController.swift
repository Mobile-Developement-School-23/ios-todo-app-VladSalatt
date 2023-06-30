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
        configure()
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
    
    func configure() {
        let model: TodoDetailView.Model = presenter?.transform() ?? .default
        customView.configure(with: model)
    }
}

// MARK: - TodoDetailPresenter Delegate

extension TodoDetailViewController: TodoDetailViewDeletage {
    func save(_ model: TodoDetailView.OutputModel) {
        presenter?.save(model)
    }
    
    func delete() {
        presenter?.delete()
    }

    func dismiss() {
        dismiss(animated: true)
    }
}

extension TodoDetailViewController: TodoDetailViewProtocol {}
