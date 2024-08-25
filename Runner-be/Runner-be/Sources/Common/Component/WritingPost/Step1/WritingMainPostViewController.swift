//
//  WritingMainPostViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import MapKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class WritingMainPostViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInputs()
    }

    init(viewModel: WritingMainPostViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WritingMainPostViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .debug()
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.next)
            .disposed(by: disposeBag)

        writeTitleView.textField.rx.text
            .subscribe(onNext: { text in
                if let text = text, !text.isEmpty {
                    self.navBar.rightBtnItem.setTitleColor(.primary, for: .normal)
                    self.navBar.rightBtnItem.isEnabled = true
                    self.navBar.rightBtnItem.titleLabel?.font = .iosBody17Sb
                    self.viewModel.inputs.editTitle.onNext(text)
                } else {
                    self.navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
                    self.navBar.rightBtnItem.isEnabled = false
                    self.navBar.rightBtnItem.titleLabel?.font = .iosBody17R
                }
            })
            .disposed(by: disposeBag)

        writeDateView.rx
            .tapGesture(configuration: { _, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            })
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.editDate)
            .disposed(by: disposeBag)

        writeTimeView.rx
            .tapGesture(configuration: { _, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            })
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.editTime)
            .disposed(by: disposeBag)

        writePlaceView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.editPlace)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.date
            .bind(to: writeDateView.contentText)
            .disposed(by: disposeBag)

        viewModel.outputs.time
            .bind(to: writeTimeView.contentText)
            .disposed(by: disposeBag)

        viewModel.outputs.placeInfo
            .bind { [weak self] result in
                self?.writePlaceView.iconTextButtonGroup.titleLabel.layer.opacity = 0.0
                self?.writePlaceView.setCityLabel.isHidden = false
                self?.writePlaceView.setDetailLabel.isHidden = false
                self?.writePlaceView.setCityLabel.text = result.city
                self?.writePlaceView.setDetailLabel.text = result.detail
            }
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private func viewInputs() {
        writeTitleView.textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.writeTitleView.textField.layer.borderWidth = 1
            })
            .disposed(by: disposeBag)

        writeTitleView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] _ in
                self?.writeTitleView.textField.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)

        vStackView.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .always
        })
        .when(.recognized)
        .filter { [weak self] recognizer in
            guard let self = self else { return false }
            return !self.writeTitleView.textField.frame.contains(recognizer.location(in: self.view))
        }
        .subscribe(onNext: { [weak self] _ in
            self?.writeTitleView.textField.endEditing(true)
        })
        .disposed(by: disposeBag)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.Post.Write.NavBar.title
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setTitle(L10n.NavBar.Right.First.next, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG5, for: .highlighted)
        navBar.rightSecondBtnItem.isHidden = true
        navBar.rightBtnItem.isEnabled = false
    }

    private var segmentedControl = SegmentedControl().then { control in
        control.defaultTextFont = .pretendardSemiBold14
        control.defaultTextColor = .darkG45
        control.highlightTextFont = .pretendardSemiBold14
        control.highlightTextColor = .darkG5
        control.fontSize = 14
        control.boxColors = [.darkG6]
        control.highlightBoxColors = [.primary, .primary]
        control.highlightBoxPadding = .zero
        control.boxPadding = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)

        // 작성화면에서는 전체 필터 제외
        control.items = RunningTag.allCases.filter { $0.code != "W" }.reduce(into: [String]()) {
            if !$1.name.isEmpty {
                $0.append($1.name)
            }
        }
    }

    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
    }

    private var writeTitleView = WritingTitleView()
    private var hDivider1 = UIView().then { $0.backgroundColor = .darkG6 }
    private var writeDateView = WritingDateView()
    private var hDivider2 = UIView().then { $0.backgroundColor = .darkG6 }
    private var writeTimeView = WritingTimeView()
    private var hDivider3 = UIView().then { $0.backgroundColor = .darkG6 }
    private var writePlaceView = WritingPlaceView()

    private lazy var vStackView = UIStackView.make(
        with: [
            writeTitleView,
            hDivider1,
            writeDateView,
            hDivider2,
            writeTimeView,
            hDivider3,
            writePlaceView,
        ],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 12
    )
}

// MARK: - Layout

extension WritingMainPostViewController {
    private func setupViews() {
        setBackgroundColor()
        segmentedControl.delegate = self

        view.addSubviews([
            navBar,
            scrollView,
        ])

        scrollView.addSubviews([
            segmentedControl,
            vStackView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(28)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
        }

        hDivider1.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(1)
        }
        hDivider2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(hDivider1)
        }
        hDivider3.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(hDivider1)
        }
    }
}

// MARK: - SegmentedControl Delegate

extension WritingMainPostViewController: SegmentedControlDelegate {
    func didChanged(_: SegmentedControl, from _: Int, to: Int) {
        // 상단 러닝태그 "전체" 선택지를 뺐기 때문에 1을 더해줍니다.
        viewModel.inputs.editTag.onNext(to + 1)
    }
}
