//
//  MeessageRoomImageListView.swift
//  Runner-be
//
//  Created by 이유리 on 6/6/24.
//

import SnapKit
import Then
import UIKit

final class MeessageRoomImageListView: UIView {
    private let scrollView = UIScrollView()
    private let hDivider = UIView().then { view in
        view.backgroundColor = .darkG5
    }

    var hStackView = UIStackView().then { view in
        view.axis = .horizontal
        view.spacing = 8
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MeessageRoomImageListView {
    func setup() {
        addSubviews([
            hDivider,
            scrollView,
        ])
        scrollView.addSubview(hStackView)
    }

    func initialLayout() {
        hDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.trailing.equalToSuperview().offset(-16)
        }

        hStackView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
    }
}
