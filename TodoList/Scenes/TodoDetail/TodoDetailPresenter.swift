//
//  TodoDetailPresenter.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoDetailViewProtocol: AnyObject {
    func dismiss()
}

protocol TodoDetailPresenterProtocol {
    init(
        id: String?,
        view: TodoDetailViewProtocol,
        router: TodoDetailRouterProtocol,
        fileCache: FileCacheProtocol,
        saveCompletion: (() -> Void)?
    )

    func transform() -> TodoDetailView.Model
    func save(_ viewItem: TodoDetailView.OutputModel)
    func delete()
}

final class TodoDetailPresenter: TodoDetailPresenterProtocol {

    // MARK: - Properties

    private let id: String?
    private weak var view: TodoDetailViewProtocol?
    private let router: TodoDetailRouterProtocol
    private let fileCache: FileCacheProtocol
    private let completion: (() -> Void)?

    // MARK: - Initializers

    init(
        id: String?,
        view: TodoDetailViewProtocol,
        router: TodoDetailRouterProtocol,
        fileCache: FileCacheProtocol,
        saveCompletion: (() -> Void)?
    ) {
        self.id = id
        self.view = view
        self.router = router
        self.fileCache = fileCache
        self.completion = saveCompletion
    }

    func transform() -> TodoDetailView.Model {
        guard
            let id,
            let item = fileCache.items[id]
        else { return .default }

        return TodoDetailView.Model(from: item)
    }

    func save(_ viewItem: TodoDetailView.OutputModel) {
        var parentItem: TodoItem?
        if let id, let item = fileCache.items[id] { parentItem = item }
        let rewritedItem = TodoItem(parent: parentItem, from: viewItem)
        fileCache.add(rewritedItem)
        view?.dismiss()
        completion?()
    }
    
    func delete() {
        guard let id else {
            view?.dismiss()
            return
        }
        fileCache.deleteItem(with: id)
        view?.dismiss()
        completion?()
    }
}

private extension TodoDetailView.Model {
    init(from item: TodoItem) {
        self.init(
            text: item.text,
            footer: DetailFooterView.Model(
                importance: DetailItemView.Model(
                    title: Strings.Detail.importance,
                    selectedIndex: item.importance.intValue
                ),
                deadline: DetailItemView.Model(
                    title: Strings.Detail.doThisUntil,
                    subtitle: item.deadline.flatMap { DateFormatter.dayWithMonth.string(from: $0) },
                    selectedDate: item.deadline
                )
            )
        )
    }
}

private extension TodoItem {
    init(parent: TodoItem?, from model: TodoDetailView.OutputModel) {
        self.init(
            id: parent?.id ?? UUID().uuidString,
            text: model.text,
            importance: Importance(from: model.importanceInt),
            deadline: model.deadLine,
            isDone: parent?.isDone ?? false,
            createdAt: parent?.createdAt ?? Date(),
            changedAt: Date()
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
