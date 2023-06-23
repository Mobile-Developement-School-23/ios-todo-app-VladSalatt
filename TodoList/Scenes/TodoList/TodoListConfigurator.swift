//
//  TodoListConfigurator.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

final class TodoListConfigurator {
    static func configure() -> UIViewController {
        let view = TodoListViewController()
        let router = TodoListRouter(view: view)
        let presenter = TodoListPresenter(view: view, router: router)
        view.presenter = presenter
        
        return view
    }
    
}
