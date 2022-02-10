//
//  PhotoModalViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

final class PhotoModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: PhotoModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: PhotoModalViewModel

    private func viewModelInput() {
        view.rx.tapGesture()
            .map { _ in }
            .subscribe(viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)

        takePhotoButton.rx.tap
            .subscribe(viewModel.inputs.tapTakePhoto)
            .disposed(by: disposeBags)

        chooseFromAlbumButton.rx.tap
            .subscribe(viewModel.inputs.tapChoosePhoto)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {}

    // MARK: - Private

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
    }

    private var sheetTitleLabel1 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = L10n.PhotoCertification.Modal.title1
        label.textAlignment = .center
    }

    private var sheetTitleLabel2 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = L10n.PhotoCertification.Modal.title2
        label.textAlignment = .center
    }

    private var hDivider1 = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var takePhotoButton = UIButton().then { button in
        button.setTitle(L10n.PhotoCertification.Modal.Button._1, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }

    private var chooseFromAlbumButton = UIButton().then { button in
        button.setTitle(L10n.PhotoCertification.Modal.Button._2, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }
}

// MARK: - Layout

extension PhotoModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([sheet])
        sheet.addSubviews([
            sheetTitleLabel1,
            sheetTitleLabel2,
            hDivider1,
            takePhotoButton,
            hDivider2,
            chooseFromAlbumButton,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(312)
            make.leading.equalTo(view.snp.leading).offset(53)
            make.trailing.equalTo(view.snp.trailing).offset(-53)
            make.height.equalTo(8 + 84 + 1 + 46 + 1 + 38 + 12)
        }

        sheetTitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(sheet.snp.leading).offset(24)
            make.trailing.equalTo(sheet.snp.trailing).offset(-24)
        }

        sheetTitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(sheetTitleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(sheet.snp.leading).offset(24)
            make.trailing.equalTo(sheet.snp.trailing).offset(-24)
        }

        hDivider1.snp.makeConstraints { make in
            make.top.equalTo(sheetTitleLabel2.snp.bottom).offset(24)
            make.height.equalTo(1)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        takePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(hDivider1.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(46)
        }

        hDivider2.snp.makeConstraints { make in
            make.top.equalTo(takePhotoButton.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        chooseFromAlbumButton.snp.makeConstraints { make in
            make.top.equalTo(hDivider2.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
        }
    }
}
