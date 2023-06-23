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
        navigationItem.title = "1"
        title = "2"
        view.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        customView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vc = TodoDetailConfigurator.configure()
        present(vc, animated: true)
    }
    
}

extension TodoListViewController: TodoListViewDelegate {
    func presentDetail() {
        let vc = TodoDetailConfigurator.configure()
        present(vc, animated: true)
    }
}

// MARK: - TodoListPresenter Delegate

extension TodoListViewController: TodoListViewProtocol {}
