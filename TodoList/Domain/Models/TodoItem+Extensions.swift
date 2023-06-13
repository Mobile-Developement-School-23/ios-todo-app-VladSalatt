import Foundation

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard
            let json = json as? String,
            let data = json.data(using: .utf8)
        else { return nil }
        
        do {
            guard
                let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return nil }
            return TodoItem(from: jsonDict)
        } catch {
            print(error)
            return nil
        }
    }
}

private extension TodoItem {
    init?(from jsonDict: [String: Any]) {
        guard
            let id = jsonDict["id"] as? String,
            let text = jsonDict["text"] as? String,
            let importanceRaw = jsonDict["importance"] as? String,
            let importance = Importance(rawValue: importanceRaw),
            let isDone = jsonDict["done"] as? Bool,
            let createdAtTS = jsonDict["created_at"] as? TimeInterval
        else { return nil }
        
        let createdAt = Date(timeIntervalSince1970: createdAtTS)
        
        let deadline: Date? = {
            guard let deadline = jsonDict["deadline"] as? TimeInterval else { return nil }
            return Date(timeIntervalSince1970: deadline)
        }()
        
        let changedAt: Date? = {
            guard let changedAt = jsonDict["changed_at"] as? TimeInterval else { return nil }
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
