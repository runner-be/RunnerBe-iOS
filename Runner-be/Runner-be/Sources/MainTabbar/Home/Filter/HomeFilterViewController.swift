//
//  HomeFilterViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class HomeFilterViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInput()
    }

    init(viewModel: HomeFilterViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: HomeFilterViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .filter {
                if self.selectRunningPaceView.selectedPaces.isEmpty {
                    AppContext.shared.makeToastWithImage(
                        "달리고 싶은 페이스 난이도를 선택해주세요!",
                        image: Asset.iconWarning20.image
                    )
                    return false
                } else {
                    return true
                }
            }
            .map { [weak self] () -> (HomeFilterViewModel.InputData)? in
                guard let self = self else { return nil }
                let paceFilter = self.selectRunningPaceView.selectedPaces
                let genderIdx = self.filterGenderView.genderLabelGroup.selected.first
                let jobIdx = self.filterJobView.jobGroup.selected.first
                var minAge = Int(self.filterAgeView.slider.selectedMinValue)
                var maxAge = Int(self.filterAgeView.slider.selectedMaxValue)
                if self.filterAgeView.checkBox.isSelected {
                    minAge = 20
                    maxAge = 65
                }
                return (paceFilter, genderIdx, jobIdx, minAge, maxAge)
            }
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .subscribe(viewModel.inputs.reset)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.paceFilter
            .take(1)
            .bind { [weak self] paceFilter in

                if paceFilter.contains("beginner") &&
                    paceFilter.contains("average") &&
                    paceFilter.contains("high") &&
                    paceFilter.contains("master")
                {
                    self?.selectRunningPaceView.allView?.isOn = true
                    self?.selectRunningPaceView.beginnerView.isOn = true
                    self?.selectRunningPaceView.averageView.isOn = true
                    self?.selectRunningPaceView.highView.isOn = true
                    self?.selectRunningPaceView.masterView.isOn = true
                    self?.selectRunningPaceView.selected = "all"
                    return
                }

                if paceFilter.contains("beginner") {
                    self?.selectRunningPaceView.beginnerView.isOn = true
                    self?.selectRunningPaceView.selected = "beginner"
                }

                if paceFilter.contains("average") {
                    self?.selectRunningPaceView.averageView.isOn = true
                    self?.selectRunningPaceView.selected = "average"
                }

                if paceFilter.contains("high") {
                    self?.selectRunningPaceView.highView.isOn = true
                    self?.selectRunningPaceView.selected = "high"
                }

                if paceFilter.contains("master") {
                    self?.selectRunningPaceView.masterView.isOn = true
                    self?.selectRunningPaceView.selected = "master"
                }

            }.disposed(by: disposeBag)

        viewModel.outputs.gender
            .take(1)
            .subscribe(onNext: { [weak self] idx in
                self?.filterGenderView.select(idx: idx)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.job
            .take(1)
            .subscribe(onNext: { [weak self] idx in
                self?.filterJobView.select(idx: idx)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.age
            .take(1)
            .subscribe(onNext: { [weak self] age in
                self?.filterAgeView.setValues(minValue: CGFloat(age.min), maxValue: CGFloat(age.max))
            })
            .disposed(by: disposeBag)

        viewModel.outputs.reset
            .subscribe(onNext: { [weak self] in
                self?.filterAgeView.reset()
                self?.filterJobView.reset()
                self?.filterGenderView.reset()
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private func viewInput() {
        selectRunningPaceView.allView?.button.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.selectRunningPaceView.allView?.isOn.toggle()
                self.selectRunningPaceView.selected = "all"
            }).disposed(by: disposeBag)

        selectRunningPaceView.beginnerView.button.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.selectRunningPaceView.beginnerView.isOn.toggle()
                self.selectRunningPaceView.selected = "beginner"
            })
            .disposed(by: disposeBag)

        selectRunningPaceView.averageView.button.rx.tap
            .subscribe(onNext: { _ in
                self.selectRunningPaceView.averageView.isOn.toggle()
                self.selectRunningPaceView.selected = "average"
            })
            .disposed(by: disposeBag)

        selectRunningPaceView.highView.button.rx.tap
            .subscribe(onNext: { _ in
                self.selectRunningPaceView.highView.isOn.toggle()
                self.selectRunningPaceView.selected = "high"
            })
            .disposed(by: disposeBag)

        selectRunningPaceView.masterView.button.rx.tap
            .subscribe(onNext: { _ in
                self.selectRunningPaceView.masterView.isOn.toggle()
                self.selectRunningPaceView.selected = "master"
            })
            .disposed(by: disposeBag)
    }

    private var selectRunningPaceView = SelectRunningPaceView(isCheckBox: true)
    private var hDivider1 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var filterGenderView = SelectGenderView()
    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var filterAgeView = SelectAgeView()
    private var hDivider3 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var filterJobView = SelectJobView()

    private lazy var vStackView = UIStackView.make(
        with: [
            selectRunningPaceView,
            hDivider1,
            filterGenderView,
            hDivider2,
            filterAgeView,
            hDivider3,
            filterJobView,
        ],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 27
    )

    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.Home.Filter.NavBar.title
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.refresh.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension HomeFilterViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
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

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
        }

        hDivider1.snp.makeConstraints { make in
            make.leading.equalTo(vStackView.snp.leading)
            make.trailing.equalTo(vStackView.snp.trailing)
            make.height.equalTo(1)
        }

        hDivider2.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.height.equalTo(1)
        }

        hDivider3.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.height.equalTo(1)
        }
    }
}
