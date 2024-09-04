//
//  TogetherRunnerCell.swift
//  Runner-be
//
//  Created by 김창규 on 9/3/24.
//

import RxSwift
import UIKit

final class TogetherRunnerCell: UITableViewCell {
    static let id: String = "\(TogetherRunnerCell.self)"

    // MARK: - Properties

    var disposeBag = DisposeBag()

    override var isSelected: Bool {
        didSet {
            // 셀이 선택된 상태인지 확인
            profileImage.layer.borderColor = isSelected ? UIColor.primary.cgColor : UIColor.clear.cgColor
            contentView.backgroundColor = isSelected ? .primary.withAlphaComponent(0.2) : .clear
        }
    }

    // MARK: - UI

    private let containerView = UIView()

    private let profileImage = UIImageView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.primary.cgColor
        $0.layer.cornerRadius = 28
    }

    private let nameLabel = UILabel().then {
        $0.text = "NickName"
        $0.textColor = .darkG1
        $0.font = .pretendardRegular18
    }

    private let readerIcon = UIImageView().then {
        $0.image = Asset.iconsWriter24.uiImage
        $0.isHidden = false
    }

    private let stampBg = UIView().then {
        $0.backgroundColor = .darkG5
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor.darkG45.cgColor
        $0.layer.borderWidth = 1
    }

    private let stampIcon = UIImageView().then {
        $0.image = Asset.runningLogRUN001.uiImage
    }

    let showLogButton = UIButton().then {
        $0.setTitle("로그 보기", for: .normal)
        $0.setTitleColor(.darkG2, for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold12
        $0.backgroundColor = .darkG55
        $0.layer.cornerRadius = 4
    }

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        initialLayout()

        contentView.isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with config: TogetherRunnerConfig) {
        disposeBag = DisposeBag()

        profileImage.kf.setImage(
            with: URL(string: config.usetProfileURL),
            placeholder: Asset.profileEmptyIcon.uiImage
        )
        stampBg.isHidden = config.stamp == nil
        stampIcon.image = config.stamp?.status?.icon
    }
}

// MARK: - Layout

extension TogetherRunnerCell {
    private func setupViews() {
        backgroundColor = .clear

        contentView.addSubviews([
            containerView,
        ])

        containerView.addSubviews([
            profileImage,
            nameLabel,
            readerIcon,
            stampBg,
            showLogButton,
        ])

        stampBg.addSubview(stampIcon)
    }

    private func initialLayout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview()
        }

        profileImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(56)
        }

        nameLabel.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.right).offset(12)
            $0.centerY.equalToSuperview()
        }

        readerIcon.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }

        stampBg.snp.makeConstraints {
            $0.right.equalTo(showLogButton.snp.left).inset(-8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }

        stampIcon.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview().inset(5)
        }

        showLogButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(64)
            $0.height.equalTo(24)
        }
    }
}
