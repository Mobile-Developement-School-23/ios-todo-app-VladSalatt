//
//  ListTitleView.swift
//  TodoList
//
//  Created by Vladislav Koshelev on 27.06.2023.
//

import UIKit

final class ListTitleView: UIView {
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var topHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .top
        stack.spacing = 2
        return stack
    }()
    
    private lazy var priorityImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body
        label.textColor = .Label.primary
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var bottomHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.isHidden = true
        return stack
    }()
    
    private lazy var calendarImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = .calendar
        image.isHidden = true
        return image
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .subhead
        label.textColor = .Label.tertiary
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Model) {
        titleLabel.attributedText = model.title
        priorityImageView.setImageOrHide(model.priority.image)

        guard let date = model.date else { return }
        bottomHorizontalStackView.isHidden = model.date == nil
        dateLabel.setTextOrHide(DateFormatter.dayWithMonth.string(from: date))
        dateLabel.isHidden = model.date == nil
        calendarImageView.isHidden = model.date == nil
    }
}

extension ListTitleView {
    struct Model {
        let title: NSAttributedString
        let priority: Priority
        let date: Date?
    }
    
    enum Priority {
        case high
        case low
        case none
    }
}

private extension ListTitleView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(
            contentStackView.addArrangedSubviews(
                topHorizontalStackView.addArrangedSubviews(
                    priorityImageView,
                    titleLabel
                ),
                bottomHorizontalStackView.addArrangedSubviews(
                    calendarImageView,
                    dateLabel
                )
            )
        )
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            priorityImageView.heightAnchor.constraint(equalToConstant: 20),
            priorityImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
        
        NSLayoutConstraint.activate([
            calendarImageView.heightAnchor.constraint(equalToConstant: 16),
            calendarImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

private extension ListTitleView.Priority {
    var image: UIImage? {
        switch self {
        case .high:
            return .Priority.high
        case .low:
            return .Priority.low
        case .none:
            return nil
        }
    }
}
