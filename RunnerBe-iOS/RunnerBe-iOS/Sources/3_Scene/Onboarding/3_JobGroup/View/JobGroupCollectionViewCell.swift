//
//  JobGroupCollectionViewCell.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/10.
//

import SnapKit
import UIKit

class JobGroupCollectionViewCell: UICollectionViewCell {
    var label: OnOffLabel? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = label {
                contentView.addSubview(view)
                view.snp.makeConstraints { make in
                    make.leading.equalTo(contentView.snp.leading)
                    make.trailing.equalTo(contentView.snp.trailing)
                    make.top.equalTo(contentView.snp.top)
                    make.bottom.equalTo(contentView.snp.bottom)
                }
            }
        }
    }
}

extension JobGroupCollectionViewCell {
    static var id: String {
        "\(JobGroupCollectionViewCell.self)"
    }
}
