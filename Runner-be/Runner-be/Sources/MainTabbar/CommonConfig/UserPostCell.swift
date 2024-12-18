//
//  UserPostCell.swift
//  Runner-be
//
//  Created by 김창규 on 12/17/24.
//

import RxSwift
import UIKit

final class UserPostCell: UICollectionViewCell {
    static let id = "\(UserPostCell.self)"

    // MARK: - Properties

    var disposeBag = DisposeBag()

    // MARK: - UI

    var postInfoView = BasicPostInfoView().then {
        $0.bookMarkIcon.isHidden = true
    }

    // MARK: - Init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func prepareForReuse() {
        postInfoView.reset()
        disposeBag = DisposeBag()
    }

    // MARK: - Methods

    func configure(with item: PostConfig) { // 작성한 글 cell 내용 구성하는 부분
        postInfoView.configure(with: item)
    }
}

// MARK: - Layout

extension UserPostCell {
    private func setup() {
        backgroundColor = .darkG55
        contentView.addSubviews([
            postInfoView,
        ])
    }

    private func initialLayout() {
        layer.cornerRadius = 12
        clipsToBounds = true

        postInfoView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview().inset(16)
        }
    }
}

extension UserPostCell {
    static let size: CGSize = .init(width: 280, height: 144)
}
