import Foundation

/// Структура, описывающая модель задачи
struct TodoItem {
    /// Уникальный идентификатор
    let id: String
    /// Текст
    let text: String
    /// Важность
    let importance: Importance
    /// Дедлайн
    let deadline: Date?
    /// Готовность. Сделана задача или нет
    let isDone: Bool
    /// Дата создания
    let createdAt: Date
    /// Дата изменения
    let changedAt: Date?

    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .basic,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdAt: Date = Date(),
        changedAt: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.changedAt = changedAt
    }
}

extension TodoItem {
    /// Поле "Важность" для задачи
    enum Importance: String, CaseIterable {
        /// неважный
        case low
        /// нормальный
        case basic
        /// важный
        case important
    }
}

extension TodoItem {
    /// Enum, в котором описаны все ключи.
    /// Используется для того, чтобы при сериализации не ошибиться в названии ключей
    enum CustomKeys: String {
        case id
        case text
        case importance
        case deadline
        case isDone = "done"
        case createdAt = "created_at"
        case changedAt = "changed_at"
    }
}
