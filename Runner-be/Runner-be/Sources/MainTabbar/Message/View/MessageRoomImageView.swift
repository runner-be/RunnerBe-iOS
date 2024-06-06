//
//  MessageRoomImageView.swift
//  Runner-be
//
//  Created by 이유리 on 5/19/24.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class MessageRoomImageView: UIImageView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var xButton = UIButton().then { view in
        view.setImage(.circleCancel, for: .normal)
    }

    init(image: UIImage) {
        super.init(frame: .zero)
        setup(image: image)
        initialLayout()
    }

    private func setup(image: UIImage) {
        self.image = image
        layer.cornerRadius = 12
        layer.masksToBounds = true
        contentMode = .scaleAspectFill

        addSubview(xButton)
    }

    private func initialLayout() {
        snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(88)
        }

        xButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }
    }
}
