//
//  WritingDetailPostViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import RxCocoa
import RxGesture
import RxKeyboard
import RxSwift
import SnapKit
import Then
import UIKit

class WritingDetailPostViewController: BaseViewController {
    typealias ViewInputData = WritingDetailPostViewModel.ViewInputData

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInput()
    }

    init(viewModel: WritingDetailPostViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WritingDetailPostViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .map { [weak self] in
                guard let self = self else { return nil }
                let genderIdx = self.selectGenderView.genderLabelGroup.selected.first ?? 0
                let ageMin = self.selectAgeView.checkBox.isSelected ?
                    self.selectAgeView.slider.minValue : self.selectAgeView.slider.selectedMinValue
                let ageMax = self.selectAgeView.checkBox.isSelected ?
                    self.selectAgeView.slider.maxValue : self.selectAgeView.slider.selectedMaxValue
                let numPerson = Int(self.selectNumParticipantView.numberLabel.text!) ?? 2
                let content = self.selectTextContentView.textField.text ?? ""

                // TODO: 추후 뒷풀이 유무, 러닝페이스 더미데이터가 아닌 실제 데이터 추가 필요
                return ViewInputData(
                    gender: genderIdx,
                    ageMin: Int(ageMin),
                    ageMax: Int(ageMax),
                    numPerson: numPerson,
                    textContent: content,
                    paceGrade: "beginner",
                    afterParty: 1
                )
            }
            .subscribe(viewModel.inputs.posting)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.writingPostData
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.summaryView.configure(with: data)
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private func viewInput() {
        vStackView.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .always
        })
        .when(.recognized)
        .filter { [weak self] recognizer in
            guard let self = self else { return false }
            return !self.selectTextContentView.textField.frame.contains(recognizer.location(in: self.view))
        }
        .subscribe(onNext: { [weak self] _ in
            self?.selectTextContentView.textField.endEditing(true)
        })
        .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.scrollView.contentInset.bottom = keyboardVisibleHeight
                let bottomOffset = CGPoint(
                    x: 0,
                    y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom
                )
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private var summaryView = SummaryMainPostView()

    private var hDivider1 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
    }

    private var selectGenderView = SelectGenderView()

    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var selectAgeView = SelectAgeView()

    private var hDivider3 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var selectNumParticipantView = SelectNumParticipantView()

    private var hDivider4 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var selectTextContentView = SelectTextContentView()

    private lazy var vStackView = UIStackView.make(
        with: [
            selectGenderView,
            hDivider2,
            selectAgeView,
            hDivider3,
            selectNumParticipantView,
            hDivider4,
            selectTextContentView,
        ],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 20
    )

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.Post.Detail.NavBar.title
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setTitle(L10n.Post.Detail.NavBar.rightItem, for: .normal)
        navBar.rightBtnItem.setTitleColor(.primary, for: .normal)
//        navBar.rightBtnItem.setTitleColor(.darkG5, for: .highlighted)
        navBar.rightBtnItem.titleLabel?.font = .iosBody17Sb
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 12
    }
}

// MARK: - Layout

extension WritingDetailPostViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            summaryView,
            hDivider1,
            scrollView,
        ])

        scrollView.addSubview(vStackView)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        summaryView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        hDivider1.snp.makeConstraints { make in
            make.top.equalTo(summaryView.snp.bottom).offset(18)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(10)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(hDivider1.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
        }

        hDivider2.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(1)
        }

        hDivider3.snp.makeConstraints { make in
            make.height.equalTo(1)
        }

        hDivider4.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
