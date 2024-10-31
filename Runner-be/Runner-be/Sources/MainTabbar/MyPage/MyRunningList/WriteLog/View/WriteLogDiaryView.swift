//
//  WriteLogDiaryView.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import RxSwift
import UIKit

enum LogDiaryType {
    case write
    case confirm
}

final class WriteLogDiaryView: UIView {
    // MARK: - Properties

    private var logDiaryType: LogDiaryType = .write
    private var isPersonalLog: Bool = true

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.text = "러닝 일기"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let title = UILabel().then {
        $0.text = "러닝 일기"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    let countLabel = UILabel().then {
        $0.text = "0/500"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    // MARK: - [START] Eidt

    let editView = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 12
    }

    let textView = PlaceholderTextView().then {
        $0.backgroundColor = .clear
        $0.font = .pretendardRegular16
        $0.textColor = .darkG35
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0

        $0.placeholder = "러닝 일기로 오늘 하루 러닝을 표현해보세요."
        $0.placeholderColor = .darkG35
    }

    let selectedImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .black
        $0.clipsToBounds = true
        $0.isHidden = true
    }

    let confirmImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isHidden = true
    }

    let selectedImageCancle = UIImageView().then {
        $0.image = Asset.circleCancelBlack.uiImage
    }

    let imageButton = UIView().then {
        $0.layer.cornerRadius = 19
        $0.backgroundColor = .darkG55
    }

    private let imageButtonTitle = UILabel().then {
        $0.text = "사진"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold16
    }

    private let imageIcon = UIImageView().then {
        $0.image = Asset.iconPhoto18.uiImage
    }

    // MARK: - [END] Eidt

    // MARK: - [START] Weather

    let weatherView = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 12
    }

    private let weatherTitleLabel = UILabel().then {
        $0.text = "날씨"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    let weatherDegreeLabel = UILabel().then {
        $0.text = "- ℃"
        $0.textColor = .darkG4
        $0.font = .pretendardRegular16
    }

    private let weatherIconBg = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .darkG55
    }

    let weatherIcon = UIImageView().then {
        $0.image = Asset.runningWeatherDefault.uiImage
    }

    // MARK: - [END] Weather

    let participantView = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 12
    }

    private let participantTitleLabel = UILabel().then {
        $0.text = "함께한 러너"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let participantTempLabel = UILabel().then {
        $0.text = "0명"
        $0.textColor = .darkG4
        $0.font = .pretendardRegular16
    }

    private let participantIconBg = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .darkG55
    }

    private let participantIcon = UIImageView().then {
        $0.image = Asset.group.uiImage
    }

    let infoWordBubble = UIImageView().then {
        $0.image = Asset.logGatheringWordbubble.image
        let label = UILabel()
        label.font = .pretendardRegular12
        label.textColor = .primary
        label.text = "같이 뛰면 사용할 수 있어요!"
        label.numberOfLines = 0

        $0.addSubview(label)
        label.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12 + 8)
        }

        $0.isHidden = true
    }

    // MARK: - Init

    init(type: LogDiaryType) {
        logDiaryType = type
        imageButton.isHidden = logDiaryType == .confirm
        confirmImageView.isHidden = logDiaryType == .write
        countLabel.isHidden = logDiaryType == .confirm

        super.init(frame: .zero)

        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func update(with stampType: StampType, temp: String) {
        weatherIcon.image = stampType.icon
        weatherDegreeLabel.text = temp + " ℃"
    }

    func updateConfirmImage(imageURL: String) {
        confirmImageView.kf.setImage(with: URL(string: imageURL))
    }

    func updateWeather(
        stamp: StampType?,
        degree: String
    ) {
        weatherIcon.image = stamp?.icon
        weatherDegreeLabel.text = degree + " ℃"
    }

    func updateGathering(
        gatheringCount: Int,
        gatheringId: Int?
    ) {
        isPersonalLog = gatheringId == nil
        participantTempLabel.text = "\(gatheringCount) 명"
        participantIcon.image = isPersonalLog ? Asset.iconLock24.uiImage : Asset.group.uiImage
    }

    func showInfoWordBubble() {
        if infoWordBubble.isHidden {
            // Ensure the bubble is visible
            infoWordBubble.alpha = 1.0
            infoWordBubble.isHidden = false

            // Delay for 1 second before starting the fade-out animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.infoWordBubble.alpha = 0.0
                }) { _ in
                    // Hide after the fade-out completes
                    self.infoWordBubble.isHidden = true
                }
            }
        }
    }
}

// MARK: - Layout

extension WriteLogDiaryView {
    private func setupViews() {
        addSubviews([
            title,
            countLabel,
            editView,
            weatherView,
            participantView,
        ])

        editView.addSubviews([
            textView,
            selectedImageView,
            confirmImageView,
            imageButton,
        ])

        selectedImageView.addSubviews([
            selectedImageCancle,
        ])

        imageButton.addSubviews([
            imageButtonTitle,
            imageIcon,
        ])

        weatherView.addSubviews([
            weatherTitleLabel,
            weatherDegreeLabel,
            weatherIconBg,
        ])

        weatherIconBg.addSubviews([
            weatherIcon,
        ])

        participantView.addSubviews([
            participantTitleLabel,
            participantTempLabel,
            participantIconBg,
            infoWordBubble,
        ])

        participantIconBg.addSubviews([
            participantIcon,
        ])
    }

    private func initialLayout() {
        title.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }

        countLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(title)
        }

        editView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
        }

        textView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }

        selectedImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(80)
        }

        selectedImageCancle.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(4)
            $0.size.equalTo(20)
        }

        confirmImageView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            if logDiaryType == .confirm {
                $0.bottom.equalToSuperview().inset(12)
            }
            $0.height.lessThanOrEqualTo(311)
        }

        imageButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(24 + 42)
            $0.right.equalToSuperview().inset(16)
            if logDiaryType == .write {
                $0.bottom.equalToSuperview().inset(12)
            }
            $0.width.equalTo(82)
            $0.height.equalTo(38)
        }

        imageIcon.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(18)
        }

        imageButtonTitle.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
        }

        weatherView.snp.makeConstraints {
            $0.top.equalTo(editView.snp.bottom).offset(24)
            $0.left.equalToSuperview()
            $0.right.equalTo(self.snp.centerX).offset(-4)
            $0.height.equalTo(138)
            $0.bottom.equalToSuperview()
        }

        weatherTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }

        weatherDegreeLabel.snp.makeConstraints {
            $0.top.equalTo(weatherTitleLabel.snp.bottom).offset(2)
            $0.left.equalTo(weatherTitleLabel)
        }

        weatherIconBg.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(14)
            $0.size.equalTo(40)
        }

        weatherIcon.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview().inset(8)
        }

        participantView.snp.makeConstraints {
            $0.top.equalTo(editView.snp.bottom).offset(24)
            $0.left.equalTo(self.snp.centerX).offset(4)
            $0.right.equalToSuperview()
            $0.height.equalTo(138)
            $0.bottom.equalToSuperview()
        }

        participantTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }

        participantTempLabel.snp.makeConstraints {
            $0.top.equalTo(participantTitleLabel.snp.bottom).offset(2)
            $0.left.equalTo(participantTitleLabel)
        }

        participantIconBg.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(14)
            $0.size.equalTo(40)
        }

        participantIcon.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview().inset(8)
        }

        infoWordBubble.snp.makeConstraints {
            $0.left.equalToSuperview().inset(8)
            $0.bottom.equalTo(participantIconBg.snp.top).offset(-4)
            $0.width.equalTo(154)
            $0.height.equalTo(48)
        }
    }
}
