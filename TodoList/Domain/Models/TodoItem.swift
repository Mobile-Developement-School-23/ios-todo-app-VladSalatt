//
//  TodoItem.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 12.06.2023.
//

import Foundation

/// Структура, описывающая модель задачи
struct TodoItem {
    /// Уникальный идентификатор
    let id: String
    /// Текст
    let text: String
    /// Приоритет (важность)
    let priority: Priority
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
        priority: Priority,
        deadline: Date?,
        isDone: Bool,
        createdAt: Date,
        changedAt: Date?
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.changedAt = changedAt
    }
}

extension TodoItem {
    /// Поле "Важность" для задачи
    enum Priority {
        /// неважный
        case minor
        /// нормальный
        case normal
        /// важный
        case high
    }
}
