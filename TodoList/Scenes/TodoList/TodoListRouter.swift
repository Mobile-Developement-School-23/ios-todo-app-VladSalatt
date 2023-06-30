//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoListRouterProtocol {
    init(view: UIViewController)
    func openDetail(
        with id: String?,
        fileCache: FileCacheProtocol,
        saveCompletion: (() -> Void)?
    )
}

final class TodoListRouter: TodoListRouterProtocol {

    // MARK: - Properties

    private weak var view: UIViewController?

    // MARK: - Initializers

    init(view: UIViewController) {
        self.view = view
    }

    func openDetail(
        with id: String?,
        fileCache: FileCacheProtocol,
        saveCompletion: (() -> Void)?
    ) {
        let detailViewController = TodoDetailConfigurator.configure(
            with: id,
            fileCache: fileCache,
            saveCompletion: saveCompletion
        )
        view?.navigationController?.present(detailViewController, animated: true)
    }
}
