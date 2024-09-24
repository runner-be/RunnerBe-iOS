//
//  LogStampCell.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

final class LogStampCell: UICollectionViewCell {
    // MARK: - Properties

    static let id = "\(LogStampCell.self)"

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.primary.cgColor : UIColor.clear.cgColor
        }
    }

    // MARK: - UI

    private let stampIcon = UIImageView().then {
        $0.image = Asset.runningLogRUN001.uiImage
    }

    // MARK: - Init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with stampType: StampType) {
        stampIcon.image = stampType.icon
    }
}

// MARK: - Layout

extension LogStampCell {
    private func setupViews() {
        contentView.backgroundColor = .darkG5
        contentView.layer.cornerRadius = 32
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor

        contentView.addSubviews([
            stampIcon,
        ])
    }

    private func initialLayout() {
        stampIcon.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview().inset(12)
            $0.size.equalTo(40)
        }
    }
}

extension LogStampCell {
    static let size: CGSize = .init(
        width: 64,
        height: 64
    )
}
