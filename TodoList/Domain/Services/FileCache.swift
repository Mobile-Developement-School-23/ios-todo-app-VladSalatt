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
    func saveAsJson(for fileName: String) throws
    func loadJson(for fileName: String)
}

final class FileCache: FileCacheProtocol {
    private enum Constants {
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
    
    func saveAsJson(for fileName: String) throws {
        let jsones = items.values.map { $0.json }

        guard
            let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { throw FileCacheError.directoryNotFound }

        let filePath = directory
            .appendingPathComponent(fileName)
            .appendingPathExtension("json")
        let data = try JSONSerialization.data(withJSONObject: jsones, options: .prettyPrinted)
        try data.write(to: filePath)
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

extension FileCache {
    enum FileCacheError: Error {
        case directoryNotFound
        
        var localizedDescription: String {
            switch self {
            case .directoryNotFound:
                return "User doesn't have document directory"
            }
        }
    }
}

private extension FileCache {
    func updateTodoItems(from rawItems: [Any]) {
        rawItems
            .compactMap { TodoItem.parse(json: $0) }
            .forEach { add($0) }
    }
}
