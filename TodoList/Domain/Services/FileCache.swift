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
    func save(as type: FileCache.FileType, to name: String) throws
    func load(_ type: FileCache.FileType, from path: String) throws
}

final class FileCache: FileCacheProtocol {
    private enum Constants {
        static let todoItems = "todoItems"
    }

    private(set) var items: [String: TodoItem] = [:]
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func add(_ item: TodoItem) {
        items[item.id] = item
    }

    func deleteItem(with id: String) {
        items[id] = nil
    }

    func save(as type: FileType, to path: String) throws {
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.directoryNotFound
        }

        let filePath = directory
            .appendingPathComponent(path)
            .appendingPathExtension(type.rawValue)

        switch type {
        case .json:
            try saveAsJson(to: filePath)
        case .csv:
            try saveAsCsv(to: filePath)
        }
    }

    func load(_ type: FileType, from path: String) throws {
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.directoryNotFound
        }

        let filePath = directory
            .appendingPathComponent(path)
            .appendingPathExtension(type.rawValue)

        switch type {
        case .json:
            try loadJson(from: filePath)
        case .csv:
            try? loadCsv(from: filePath)
        }
    }
}

extension FileCache {
    enum FileType: String {
        case json
        case csv
    }

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
    func saveAsJson(to path: URL) throws {
        let jsones = items.values.map { $0.json }
        let data = try JSONSerialization.data(withJSONObject: jsones, options: .prettyPrinted)
        try data.write(to: path)
    }

    func saveAsCsv(to path: URL) throws {
        let csv = items.values.map { $0.csv }.joined(separator: "\n")
        try csv.write(to: path, atomically: true, encoding: .utf8)
    }

    func loadJson(from path: URL) throws {
        guard
            let data = try? Data(contentsOf: path),
            let rawItems = try JSONSerialization.jsonObject(with: data) as? [Any]
        else { return }
        updateTodoItems(from: rawItems)
    }

    func loadCsv(from path: URL) throws {
        let rawItems = try String(contentsOf: path).split(separator: ",").map(String.init)
        updateTodoItems(from: rawItems)
    }

    func updateTodoItems(from rawItems: [Any]) {
        rawItems
            .compactMap { TodoItem.parse(with: $0) }
            .forEach { add($0) }
    }
}
