//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoListRouterProtocol {
    init(view: UIViewController)
}

final class TodoListRouter: TodoListRouterProtocol {
    
    // MARK: - Properties
    
    private weak var view: UIViewController?
    
    // MARK: - Initializers
    
    init(view: UIViewController) {
        self.view = view
    }
    
}
