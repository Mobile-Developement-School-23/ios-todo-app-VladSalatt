//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

final class TodoListViewController: UIViewController {

    // MARK: - Properties

    var presenter: TodoListPresenterProtocol?
    private lazy var customView = TodoListView()

    // MARK: - UIViewController Events

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()

        customView.delegate = self
    }
}

// MARK: - Delegates

extension TodoListViewController: TodoListViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int? {
        presenter?.tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        presenter?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func done(by row: Int) {
        presenter?.done(by: row)
    }
    
    func info(by row: Int) {
        presenter?.info(by: row)
    }
    
    func delete(by row: Int) {
        presenter?.delete(by: row)
    }
    
    func plusButtonTapped() {
        presenter?.openEmptyDetails()
    }
}

extension TodoListViewController: TodoListViewProtocol {
    func reloadData() {
        customView.reloadData()
    }
}

// MARK: - Private

private extension TodoListViewController {
    func setupUI() {
        view.addSubviews(customView)

        setupContraints()
    }

    func setupContraints() {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupNavigationBar() {
        title = Strings.List.myMatters
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins.left = 32
    }
}
