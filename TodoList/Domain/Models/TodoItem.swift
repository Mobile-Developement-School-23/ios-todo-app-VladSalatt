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
        importance: Importance,
        deadline: Date?,
        isDone: Bool,
        createdAt: Date,
        changedAt: Date?
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
    enum Importance: String {
        /// неважный
        case low
        /// нормальный
        case basic
        /// важный
        case important
    }
}
