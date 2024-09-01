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

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.text = "5줄 러닝 일기"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let title = UILabel().then {
        $0.text = "5줄 러닝 일기"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let countLabel = UILabel().then {
        $0.text = "0/500"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    // MARK: - [START] Eidt

    private let editView = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 12
    }

    private let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = .pretendardRegular16
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0

        // NSMutableParagraphStyle 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 22.0 / $0.font!.lineHeight

        // 기존 텍스트에 paragraphStyle 적용
        let attributedString = NSMutableAttributedString(string: "5줄 일기로 오늘 하루 러닝을 표현해보세요.", attributes: [
            .font: $0.font!,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.darkG35,
        ])

        $0.attributedText = attributedString
    }

    private let selectedImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .black
    }

    private let confirmImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .black
        $0.isHidden = true
    }

    private let selectedImageCancle = UIImageView().then {
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

    private let weatherTempLabel = UILabel().then {
        $0.text = "+24 C"
        $0.textColor = .darkG4
        $0.font = .pretendardRegular16
    }

    private let weatherIconBg = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .darkG55
    }

    private let weatherIcon = UIImageView().then {
        $0.image = Asset.runningWeatherSunny.uiImage
    }

    // MARK: - [END] Weather

    private let participantView = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 12
    }

    private let participantTitleLabel = UILabel().then {
        $0.text = "함께한 러너"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let participantTempLabel = UILabel().then {
        $0.text = "8명"
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

    // MARK: - Init

    init(type: LogDiaryType) {
        logDiaryType = type
        imageButton.isHidden = logDiaryType == .confirm
        selectedImageView.isHidden = logDiaryType == .confirm
        confirmImageView.isHidden = logDiaryType == .write

        super.init(frame: .zero)

        setupViews()
        initialLayout()

        textView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
}

// MARK: - TextViewDelegate

extension WriteLogDiaryView: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
//        let lineHeight = textView.font?.lineHeight ?? 0
//        let maxHeight = lineHeight * 5 // 최대 5줄까지만 입력 허용
//
//        if textView.contentSize.height > maxHeight {
//            // 텍스트가 최대 라인 수를 초과할 경우 마지막 입력을 제거
//            textView.text = String(textView.text.dropLast())
//        }
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
            weatherTempLabel,
            weatherIconBg,
        ])

        weatherIconBg.addSubviews([
            weatherIcon,
        ])

        participantView.addSubviews([
            participantTitleLabel,
            participantTempLabel,
            participantIconBg,
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
            $0.height.equalTo(self.logDiaryType == .write ? 242 : 473)
        }

        textView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(110)
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
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(311)
        }

        imageButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
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

        weatherTempLabel.snp.makeConstraints {
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
    }
}
