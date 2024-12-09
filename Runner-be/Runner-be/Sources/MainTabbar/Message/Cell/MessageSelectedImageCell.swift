//
//  MessageSelectedImageCell.swift
//  Runner-be
//
//  Created by 김창규 on 7/7/24.
//

import RxSwift
import UIKit

class MessageSelectedImageCell: UICollectionViewCell {
    static let id = "MessageSelectedImageCell"
    var disposeBag = DisposeBag()

    // MARK: - UI

    let imageView = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor(white: 1, alpha: 0.2).cgColor
        $0.layer.borderWidth = 1
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    let cancleButton = UIImageView().then {
        $0.image = UIImage(named: "circle-cancel-black")
        $0.layer.cornerRadius = 8
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func configure(
        image: UIImage,
        tag: Int
    ) {
        disposeBag = DisposeBag()
        imageView.image = image
        self.tag = tag
    }
}

// MARK: - Layout

extension MessageSelectedImageCell {
    private func setupViews() {
        addSubviews([
            imageView,
            cancleButton,
        ])
    }

    private func initialLayout() {
        imageView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
            $0.height.equalTo(80)
        }

        cancleButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(4)
            $0.size.equalTo(20)
        }
    }
}
