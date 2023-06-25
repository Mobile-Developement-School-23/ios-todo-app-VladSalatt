//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoListViewProtocol: AnyObject {}

protocol TodoListPresenterProtocol {
    init(
        view: TodoListViewProtocol,
        router: TodoListRouterProtocol
    )
}

final class TodoListPresenter: TodoListPresenterProtocol {

    // MARK: - Properties

    private weak var view: TodoListViewProtocol?
    private let router: TodoListRouterProtocol

    // MARK: - Initializers

    init(
        view: TodoListViewProtocol,
        router: TodoListRouterProtocol
    ) {
        self.view = view
        self.router = router
    }
}
