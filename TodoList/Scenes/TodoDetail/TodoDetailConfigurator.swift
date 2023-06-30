//
//  TodoDetailConfigurator.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

final class TodoDetailConfigurator {
    static func configure(
        with id: String?,
        fileCache: FileCacheProtocol,
        saveCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        let view = TodoDetailViewController()
        let router = TodoDetailRouter(view: view)
        let presenter = TodoDetailPresenter(
            id: id,
            view: view,
            router: router,
            fileCache: fileCache,
            saveCompletion: saveCompletion
        )
        view.presenter = presenter

        return view
    }

}
