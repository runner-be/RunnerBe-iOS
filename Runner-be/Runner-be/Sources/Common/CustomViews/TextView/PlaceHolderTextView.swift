//
//  PlaceHolderTextView.swift
//  Runner-be
//
//  Created by 김창규 on 9/2/24.
//

import UIKit

class PlaceholderTextView: UITextView {
    // Placeholder label
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    var placeholderColor: UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    override var text: String! {
        didSet {
            textChanged()
        }
    }

    override var attributedText: NSAttributedString! {
        didSet {
            textChanged()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
        initialLayout()
        setupPlaceholder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        initialLayout()
        setupPlaceholder()
    }

    private func setupPlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = font
        placeholderLabel.isHidden = !text.isEmpty

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc private func textChanged() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Layout

extension PlaceholderTextView {
    private func setupViews() {
        addSubview(placeholderLabel)
    }

    private func initialLayout() {
        placeholderLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
    }
}
