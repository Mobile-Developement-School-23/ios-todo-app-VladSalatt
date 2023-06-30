//
//  TodoListView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 17.06.2023.
//

import UIKit

protocol TodoListViewDelegate: AnyObject {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    func done(by row: Int)
    func info(by row: Int)
    func delete(by row: Int)
    
    func plusButtonTapped()
}

final class TodoListView: UIView {

    weak var delegate: TodoListViewDelegate?

    private lazy var tableHeaderView = ListTableHeaderView()
    
    private lazy var tableView: ListTableView = {
        let table = ListTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(ListCellView.self, forCellReuseIdentifier: ListCellView.identifier)
        return table
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.plusButton, for: .normal)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize.init(width: 0, height: 8)
        return button
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        bindUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

private extension TodoListView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .Back.primary

        addSubviews(
            tableHeaderView,
            tableView,
            plusButton
        )

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableHeaderView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            tableHeaderView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            tableHeaderView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func bindUI() {
        plusButton.addAction(plusButtonAction, for: .touchUpInside)
    }
}

private extension TodoListView {
    var plusButtonAction: UIAction {
        UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.plusButtonTapped()
        }
    }
}

extension TodoListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        delegate?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}

extension TodoListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction.makeAction(
            with: .RadioButton.white,
            color: .Color.green,
            completion: { [weak self] in
                self?.delegate?.done(by: indexPath.row)
            }
        )
        
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return UISwipeActionsConfiguration(actions: [
            .makeAction(
                with: .whiteTrash,
                color: .Color.red,
                completion: { [weak self] in
                    self?.delegate?.delete(by: indexPath.row)
                }
            ),
            .makeAction(
                with: .whiteInfo,
                color: .Color.grayLight,
                completion: { [weak self] in
                    self?.delegate?.info(by: indexPath.row)
                }
            )
        ])
    }
}

private extension UIContextualAction {
    static func makeAction(
        with image: UIImage?,
        color: UIColor?,
        completion: (() -> Void)? = nil
    ) -> UIContextualAction {
        guard let image, let color else {
            return UIContextualAction(style: .normal, title: "Sample", handler: {_, _, _ in})
        }
        let action = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { _, _, _ in completion?() }
        )
        action.image = image
        action.backgroundColor = color
        return action
    }
}
