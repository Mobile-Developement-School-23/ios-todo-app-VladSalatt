//
//  TodoDetailPresenter.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoDetailViewProtocol: AnyObject {}

protocol TodoDetailPresenterProtocol {
    init(
        view: TodoDetailViewProtocol,
        router: TodoDetailRouterProtocol,
        fileCache: FileCacheProtocol
    )

    func makeModel() -> TodoDetailView.Model?
    func save(_ item: TodoItem)
}

final class TodoDetailPresenter: TodoDetailPresenterProtocol {

    // MARK: - Properties

    private weak var view: TodoDetailViewProtocol?
    private let router: TodoDetailRouterProtocol
    private let fileCache: FileCacheProtocol

    // MARK: - Initializers

    init(
        view: TodoDetailViewProtocol,
        router: TodoDetailRouterProtocol,
        fileCache: FileCacheProtocol
    ) {
        self.view = view
        self.router = router
        self.fileCache = fileCache
    }

    func makeModel() -> TodoDetailView.Model? {
        try? fileCache.load(.json, from: "items")
        let item = fileCache.items.randomElement()?.value

        return TodoDetailView.Model(
            text: item?.text ?? "",
            footer: DetailFooterView.Model(
                importance: DetailItemView.Model(
                    title: "Важность",
                    subtitle: nil,
                    selectedIndex: item?.importance.intValue,
                    selectedDate: nil
                ),
                deadline: DetailItemView.Model(
                    title: "Сделать до",
                    subtitle: item?.deadline.flatMap { DateFormatter.dayWithMonth.string(from: $0) },
                    selectedIndex: nil,
                    selectedDate: item?.deadline
                )
            )
        )
    }

    func save(_ item: TodoItem) {
        fileCache.add(item)
    }
}

private extension TodoItem.Importance {
    var intValue: Int {
        switch self {
        case .low:
            return 0
        case .basic:
            return 1
        case .important:
            return 2
        }
    }
}
