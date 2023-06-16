//
//  FileCache.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 14.06.2023.
//

import Foundation

protocol FileCacheProtocol {
    var items: [String: TodoItem] { get }
    func add(_ item: TodoItem)
    func deleteItem(with id: String)
    func saveAsJson(for fileName: String)
    func loadJson(for fileName: String)
}

final class FileCache: FileCacheProtocol {
    enum Constants {
        static let todoItems = "todoItems"
    }
    
    private(set) var items: [String: TodoItem] = [:]
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
        self.loadJson(for: Constants.todoItems)
    }
    
    func add(_ item: TodoItem) {
        items[item.id] = item
    }
    
    func deleteItem(with id: String) {
        items[id] = nil
    }
    
    func saveAsJson(for fileName: String) {
        let jsones = items.values.map { $0.json }

        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = directory
            .appendingPathComponent(fileName)
            .appendingPathExtension("json")

        do {
            let data = try JSONSerialization.data(withJSONObject: jsones, options: .prettyPrinted)
            try data.write(to: filePath)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func loadJson(for fileName: String) {
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = directory
            .appendingPathComponent(fileName)
            .appendingPathExtension("json")
            
        guard
            let data = try? Data(contentsOf: filePath),
            let rawTodoItems = try? JSONSerialization.jsonObject(with: data) as? [Any]
        else { return }
        
        updateTodoItems(from: rawTodoItems)
    }
}

private extension FileCache {
    func updateTodoItems(from rawItems: [Any]) {
        items.removeAll()
        
        rawItems
            .compactMap { TodoItem.parse(json: $0) }
            .forEach { items[$0.id] = $0 }
    }
}
