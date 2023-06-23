//
//  TodoDetailConfigurator.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

final class TodoDetailConfigurator {
    static func configure() -> UIViewController {
        let view = TodoDetailViewController()
        let router = TodoDetailRouter(view: view)
        let fileCache = FileCache(fileManager: .default)
        let presenter = TodoDetailPresenter(view: view, router: router, fileCache: fileCache)
        view.presenter = presenter
        
        return view
    }
    
}
