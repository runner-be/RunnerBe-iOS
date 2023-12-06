//
//  BasicPostCell.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/20.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BasicPostCell: UICollectionViewCell {
    enum State {
        case open
        case closed
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    func configure(with item: PostCellConfig) {
        postInfoView.configure(with: item)
        postState = item.closed ? .closed : .open
    }

    override func prepareForReuse() {
        postState = .open

        postInfoView.reset()
        disposeBag = DisposeBag()
    }

    var disposeBag = DisposeBag()

    var postState: State = .closed

    var blurAlpha: CGFloat = Constants.Cover.blur

    var postInfoView = BasicPostInfoView()

    enum Constants {
        static let MarginX: CGFloat = 12
        static let backgroundColor: UIColor = .darkG55
        static let cornerRadius: CGFloat = 12

        enum PostInfo {
            static let top: CGFloat = 16
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
            static let bottom: CGFloat = 16 // Auto Layout으로 조정 X
        }

        enum Cover {
            static let blur: CGFloat = 0.7
        }
    }
}

extension BasicPostCell {
    private func setup() {
        backgroundColor = Constants.backgroundColor
        contentView.addSubviews([
            postInfoView,
        ])
    }

    private func initialLayout() {
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true

        postInfoView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constants.PostInfo.top)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.PostInfo.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(Constants.PostInfo.trailing)
        }
    }
}

extension BasicPostCell {
    static let id: String = "\(BasicPostCell.self)"

    static let size: CGSize = {
        let width: CGFloat = UIScreen.main.bounds.width - Constants.MarginX * 2
        let height: CGFloat = Constants.PostInfo.top
            + BasicPostInfoView.height
            + Constants.PostInfo.bottom
        return CGSize(width: width, height: height)
    }()
}
