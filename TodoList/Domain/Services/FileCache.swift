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
    func saveAsJson()
    func loadJson()
}

final class FileCache: FileCacheProtocol {
    enum Constants {
        static let fileName = "todoItems.json"
    }
    
    private(set) var items: [String: TodoItem] = [:]
    private let fileManager: FileManager
    // Сделано для того, чтобы при инициализации массив items был УЖЕ был заполнен
//    init() {
//        self.items = loadJson()
//    }
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func add(_ item: TodoItem) {
        items[item.id] = item
    }
    
    func deleteItem(with id: String) {
        items[id] = nil
    }
    
    func saveAsJson() {
        let jsonString: String = {
            let result = items.values
                .compactMap { item -> String? in
                    guard
                        let data = item.json as? Data,
                        let resultString = String(data: data, encoding: .utf8)
                    else { return nil }
                    return resultString
                }.joined(separator: ",")
            return "[\(result)]"
        }()
        
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = directory.appendingPathComponent(Constants.fileName)

        do {
            try jsonString.write(to: filePath, atomically: false, encoding: .utf8)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func loadJson() {
    }
}
