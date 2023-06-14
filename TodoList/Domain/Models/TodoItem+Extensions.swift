import Foundation

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        var data: Data?

        // Такой маппинг нужен для того, чтобы обрабатывать различные входные типы данных
        switch json {
        case is Data:
            data = json as? Data
        case is String:
            let json = json as? String
            data = json?.data(using: .utf8)
        case is [String: Any]:
            let jsonDict = json as? [String: Any] ?? [:]
            return TodoItem(from: jsonDict)
        default:
            return nil
        }
        
        guard let data else { return nil }
        
        do {
            guard
                let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return nil }
            return TodoItem(from: jsonDict)
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
    
    var json: Any {
        [
            CustomKeys.id.rawValue: id,
            CustomKeys.text.rawValue: text,
            CustomKeys.importance.rawValue: importance == .basic ? nil : importance.rawValue,
            CustomKeys.deadline.rawValue: deadline == nil ? nil : deadline.flatMap { $0.timeIntervalSince1970 },
            CustomKeys.isDone.rawValue: isDone,
            CustomKeys.createdAt.rawValue: createdAt.timeIntervalSince1970,
            CustomKeys.changedAt.rawValue: changedAt == nil ? nil : deadline.flatMap { $0.timeIntervalSince1970}
        ] as [String: Any?]
    }
}

private extension TodoItem {
    /// Инициализатор, который преобразует словарь типа [String: Any] (aka json) в объект типа TodoItem
    init?(from jsonDict: [String: Any]) {
        guard
            let id = jsonDict[CustomKeys.id.rawValue] as? String,
            let text = jsonDict[CustomKeys.text.rawValue] as? String,
            let importanceRaw = jsonDict[CustomKeys.importance.rawValue] as? String,
            let importance = Importance(rawValue: importanceRaw),
            let isDone = jsonDict[CustomKeys.isDone.rawValue] as? Bool,
            let createdAtTS = jsonDict[CustomKeys.createdAt.rawValue] as? TimeInterval
        else { return nil }
        
        let createdAt = Date(timeIntervalSince1970: createdAtTS)
        
        let deadline: Date? = {
            guard let deadline = jsonDict[CustomKeys.deadline.rawValue] as? TimeInterval else { return nil }
            return Date(timeIntervalSince1970: deadline)
        }()
        
        let changedAt: Date? = {
            guard let changedAt = jsonDict[CustomKeys.changedAt.rawValue] as? TimeInterval else { return nil }
            return Date(timeIntervalSince1970: changedAt)
        }()
        
        self.init(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            createdAt: createdAt,
            changedAt: changedAt
        )
    }
}
