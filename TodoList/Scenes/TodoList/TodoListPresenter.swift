//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoListViewProtocol: AnyObject {
    func reloadData()
}

protocol TodoListPresenterProtocol {
    init(
        view: TodoListViewProtocol,
        router: TodoListRouterProtocol,
        fileCache: FileCacheProtocol
    )
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    func openEmptyDetails()
    
    func done(by row: Int)
    func info(by row: Int)
    func delete(by row: Int)
}

final class TodoListPresenter: TodoListPresenterProtocol {

    private weak var view: TodoListViewProtocol?
    private let router: TodoListRouterProtocol
    private let fileCache: FileCacheProtocol

    init(
        view: TodoListViewProtocol,
        router: TodoListRouterProtocol,
        fileCache: FileCacheProtocol
    ) {
        self.view = view
        self.router = router
        self.fileCache = fileCache
    }
}

extension TodoListPresenter {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.items.values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListCellView.identifier,
                for: indexPath
            ) as? ListCellView
        else { return UITableViewCell() }
        
        let todoItem = fileCache.items.values[indexPath.row]
        cell.configure(with: ListCellView.Model(from: todoItem))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = fileCache.items.keys[indexPath.row]
        router.openDetail(
            with: id,
            fileCache: fileCache,
            saveCompletion: { [weak self] in
                self?.view?.reloadData()
            }
        )
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func done(by row: Int) {
        print("done", row)
        var item = fileCache.items.values[row]
        item.setIdDone(true)
        fileCache.add(item)
        view?.reloadData()
    }
    
    func info(by row: Int) {
        print("info", row)
    }
    
    func delete(by row: Int) {
        print("delete", row)
        let id = fileCache.items.keys[row]
        fileCache.deleteItem(with: id)
        view?.reloadData()
    }
    
    func openEmptyDetails() {
        router.openDetail(
            with: nil,
            fileCache: fileCache,
            saveCompletion: { [weak self] in
                self?.view?.reloadData()
            }
        )
    }
}

private extension ListCellView.Model {
    init(from item: TodoItem) {
        let state = ListCellView.State(from: item.importance, isDone: item.isDone)
        let title = NSAttributedString(from: item.text, state: state)
        
        self.init(
            titleModel: ListTitleView.Model(
                title: title,
                priority: ListTitleView.Priority(from: item.importance),
                date: item.deadline
            ),
            state: state
        )
    }
 }

private extension NSAttributedString {
    convenience init(from text: String, state: ListCellView.State) {
        let attrs: [NSAttributedString.Key: Any]? = state == .done
        ? [
            .strikethroughStyle: 1,
            .foregroundColor: UIColor.Label.tertiary as Any
        ]
        : nil
          
        self.init(string: text, attributes: attrs)
    }
}

private extension ListTitleView.Priority {
    init(from importance: TodoItem.Importance) {
        switch importance {
        case .low:
            self = .low
        case .basic:
            self = .none
        case .important:
            self = .high
        }
    }
}

private extension ListCellView.State {
    init(from importance: TodoItem.Importance, isDone: Bool) {
        guard !isDone else {
            self = .done
            return
        }
        self = importance == .important ? .important : .undone
    }
}
