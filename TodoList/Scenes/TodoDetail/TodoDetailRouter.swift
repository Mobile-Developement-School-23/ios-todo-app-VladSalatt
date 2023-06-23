//
//  TodoDetailRouter.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoDetailRouterProtocol {
    init(view: UIViewController)
}

final class TodoDetailRouter: TodoDetailRouterProtocol {
    
    // MARK: - Properties
    
    private weak var view: UIViewController?
    
    // MARK: - Initializers
    
    init(view: UIViewController) {
        self.view = view
    }
    
}
