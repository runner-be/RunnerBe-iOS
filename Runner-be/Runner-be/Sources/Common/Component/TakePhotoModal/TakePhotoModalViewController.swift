//
//  TakePhotoModalViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class TakePhotoModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: TakePhotoModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: TakePhotoModalViewModel

    private func viewModelInput() {
        sheet.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)

        view.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .map { _ in }
        .subscribe(viewModel.inputs.tapBackward)
        .disposed(by: disposeBag)

        takePhotoButton.rx.tap
            .subscribe(viewModel.inputs.tapTakePhoto)
            .disposed(by: disposeBag)

        chooseFromAlbumButton.rx.tap
            .subscribe(viewModel.inputs.tapChoosePhoto)
            .disposed(by: disposeBag)

        chooseDefault.rx.tap
            .subscribe(viewModel.inputs.tapChooseDefault)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    private var hDivider1 = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var takePhotoButton = UIButton().then { button in
        button.setTitle(L10n.Modal.TakePhoto.Button.photo, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }

    private var chooseFromAlbumButton = UIButton().then { button in
        button.setTitle(L10n.Modal.TakePhoto.Button.album, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }

    private var chooseDefault = UIButton().then { button in
        button.setTitle(L10n.Modal.TakePhoto.Button.default, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }
}

// MARK: - Layout

extension TakePhotoModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            takePhotoButton,
            hDivider1,
            chooseFromAlbumButton,
            hDivider2,
            chooseDefault,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(270)
            make.height.equalTo(158)
        }

        takePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(52)
        }

        hDivider1.snp.makeConstraints { make in
            make.top.equalTo(takePhotoButton.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        chooseFromAlbumButton.snp.makeConstraints { make in
            make.top.equalTo(hDivider1.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(52)
        }

        hDivider2.snp.makeConstraints { make in
            make.top.equalTo(chooseFromAlbumButton.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        chooseDefault.snp.makeConstraints { make in
            make.top.equalTo(hDivider2.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
        }
    }
}
