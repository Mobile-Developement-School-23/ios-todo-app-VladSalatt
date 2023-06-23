import Foundation

extension TodoItem {
    static func parse(with data: Any) -> TodoItem? {
        switch data {
        case is [String: Any]:
            guard let json = data as? [String: Any] else { return nil }
            return TodoItem(from: json)
        case is String:
            guard let csv = data as? String else { return nil }
            return TodoItem(from: csv)
        default:
            return nil
        }
    }
    
    var json: Any {
        [
            CustomKeys.id.rawValue: id,
            CustomKeys.text.rawValue: text,
            CustomKeys.importance.rawValue: importance == .basic ? nil : importance.rawValue as Any,
            CustomKeys.deadline.rawValue: deadline == nil ? nil : deadline.flatMap { $0.timeIntervalSince1970 },
            CustomKeys.isDone.rawValue: isDone,
            CustomKeys.createdAt.rawValue: createdAt.timeIntervalSince1970,
            CustomKeys.changedAt.rawValue: changedAt == nil ? nil : deadline.flatMap { $0.timeIntervalSince1970 }
        ].compactMapValues { $0 }
    }
    
    var csv: String {
        [
            id,
            text,
            importance == .basic ? nil : importance.rawValue,
            deadline.flatMap { "\($0.timeIntervalSince1970)" },
            "\(isDone)",
            "\(createdAt.timeIntervalSince1970)",
            changedAt.flatMap { "\($0.timeIntervalSince1970)" }
        ].compactMap { $0 }.joined(separator: ",")
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
    
    init?(from csv: String) {
        let comps = csv.components(separatedBy: ",")
        guard comps.count == 7 else { return nil }
        let (id, text, importance, deadline, isDone, createdAt, changedAt) = (
            comps[0],
            comps[1],
            Importance(rawValue: comps[2]) ?? .basic,
            TimeInterval(comps[3]).flatMap(Date.init(timeIntervalSince1970:)),
            Bool(comps[4]) ?? false,
            TimeInterval(comps[5]).flatMap(Date.init(timeIntervalSince1970:)) ?? Date(),
            TimeInterval(comps[6]).flatMap(Date.init(timeIntervalSince1970:))
        )
        
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
