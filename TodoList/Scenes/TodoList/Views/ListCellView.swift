//
//  TodoItemListCellView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 27.06.2023.
//

import UIKit

final class ListCellView: UITableViewCell {
    static let identifier = "ListCellViewId"
    
    private enum Constants {
        static let margin: CGFloat = 16
    }

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()
    
    private lazy var radioImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var titleView = ListTitleView()
 
    private lazy var chevronImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = .chevronRight
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Model) {
        titleView.configure(with: model.titleModel)
        radioImageView.setImageOrHide(model.state.image)
    }
}

extension ListCellView {
    struct Model {
        let titleModel: ListTitleView.Model
        let state: State
    }
    
    enum State {
        case done
        case undone
        case important
    }
}

private extension ListCellView {
    func setupUI() {
        backgroundColor = .Back.secondary
        
        addSubviews(
            contentStackView.addArrangedSubviews(
                radioImageView,
                titleView,
                chevronImageView
            )
        )

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.margin),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.margin),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.margin),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.margin),
        ])

        NSLayoutConstraint.activate([
            radioImageView.heightAnchor.constraint(equalToConstant: 24),
            radioImageView.widthAnchor.constraint(equalToConstant: 24),
        ])
        
        chevronImageView.setContentHuggingPriority(.required, for: .horizontal)
    }
}

private extension ListCellView.State {
    var image: UIImage? {
        switch self {
        case .done:
            return .RadioButton.green
        case .undone:
            return .RadioButton.gray
        case .important:
            return .RadioButton.red
        }
    }
}
