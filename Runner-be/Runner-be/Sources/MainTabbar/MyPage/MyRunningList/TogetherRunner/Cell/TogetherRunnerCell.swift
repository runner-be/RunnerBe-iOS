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

    let profileImage = UIImageView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.primary.cgColor
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
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

    // MARK: - LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()
//        showLogButton.snp.remakeConstraints {
//            $0.right.equalTo(showLogButton.snp.left).inset(-8)
//            $0.centerY.equalToSuperview()
//            $0.size.equalTo(32)
//        }
    }

    // MARK: - Methods

    // FIXME: 조장을 인덱스 첫번째일 경우로 임시 설정됨 API수정후 앱적용
    func configure(
        with config: TogetherRunnerConfig,
        index: Int,
        logId: Int?
    ) {
        disposeBag = DisposeBag()
        nameLabel.text = config.nickname
        readerIcon.isHidden = index != 0
        profileImage.kf.setImage(
            with: URL(string: config.profileImageUrl ?? ""),
            placeholder: Asset.profileEmptyIcon.uiImage
        )
        if let stampCode = config.stampCode,
           let stamp = StampType(rawValue: stampCode)
        {
            stampBg.isHidden = false
            stampIcon.image = stamp.icon
        } else {
            stampBg.isHidden = true
        }

        updateLogButton(with: config, logId: logId)
    }

    // FIXME: 임시
    private func updateLogButton(
        with config: TogetherRunnerConfig,
        logId: Int?
    ) {
        let isOpened = (config.isOpened == 1)
        if logId == nil {
            showLogButton.snp.makeConstraints {
                $0.width.equalTo(0)
            }
            return
        }

        if isOpened {
            showLogButton.layer.opacity = 1
            showLogButton.setTitle("로그 보기", for: .normal)
            showLogButton.isUserInteractionEnabled = true
        } else {
            showLogButton.layer.opacity = 0.2
            showLogButton.setTitle("비공개", for: .normal)
            showLogButton.isUserInteractionEnabled = false
        }
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
