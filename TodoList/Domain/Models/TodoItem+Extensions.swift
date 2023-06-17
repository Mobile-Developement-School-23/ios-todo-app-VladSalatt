import Foundation

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let json = json as? [String: Any] else { return nil }
        return TodoItem(from: json)
    }
    
    var json: Any {
        [
            CustomKeys.id.rawValue: id,
            CustomKeys.text.rawValue: text,
            CustomKeys.importance.rawValue: importance == .basic ? nil : importance.rawValue,
            CustomKeys.deadline.rawValue: deadline == nil ? nil : deadline.flatMap { $0.timeIntervalSince1970 },
            CustomKeys.isDone.rawValue: isDone,
            CustomKeys.createdAt.rawValue: createdAt.timeIntervalSince1970,
            CustomKeys.changedAt.rawValue: changedAt == nil ? nil : deadline.flatMap { $0.timeIntervalSince1970 }
        ] as [String: Any?]
    }
}

private extension TodoItem {
    /// Инициализатор, который преобразует словарь типа [String: Any] (aka json) в объект типа TodoItem
    init?(from jsonDict: [String: Any]) {
        guard
            let id = jsonDict[CustomKeys.id.rawValue] as? String,
            let text = jsonDict[CustomKeys.text.rawValue] as? String,
            let createdAtTS = jsonDict[CustomKeys.createdAt.rawValue] as? TimeInterval
        else { return nil }
        let importance = (jsonDict[CustomKeys.importance.rawValue] as? String).flatMap(Importance.init(rawValue:)) ?? .basic
        let deadline = (jsonDict[CustomKeys.deadline.rawValue] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))
        let isDone = (jsonDict[CustomKeys.isDone.rawValue] as? Bool) ?? false
        let createdAt = Date(timeIntervalSince1970: createdAtTS)
        let changedAt = (jsonDict[CustomKeys.changedAt.rawValue] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))
        
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
