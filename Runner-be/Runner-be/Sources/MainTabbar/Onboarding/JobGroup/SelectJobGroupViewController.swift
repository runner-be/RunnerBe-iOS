//
//  SelectJobGroupViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

final class SelectJobGroupViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SelectJobGroupViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: SelectJobGroupViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .bind(to: viewModel.inputs.tapComplete)
            .disposed(by: disposeBag)

        jobGroupView.jobGroup.tap
            .compactMap { $0 }
            .map { [weak self] numSelected in
                guard let self = self else { return [] }
                return (numSelected != 0) ? self.jobGroupView.jobGroup.selected : []
            }
            .bind(to: viewModel.inputs.tapGroup)
            .disposed(by: disposeBag)

        // TODO: 직군 종류들을 ViewModel로 넘길지 고민해보기
//        let jobGroupLabels = Observable.of(jobLabels)
//        jobGroupLabels.bind(
//            to: jobGroupCollectionView.rx.items(
//                cellIdentifier: JobGroupCollectionViewCell.id,
//                cellType: JobGroupCollectionViewCell.self
//            )
//        ) { _, label, cell in cell.label = label }
//            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableComplete
            .subscribe(onNext: { [weak self] enable in
                self?.completeButton.isEnabled = enable
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.attributedText = NSMutableAttributedString()
            .style(to: "4", attributes: [
                .font: UIFont.iosBody17Sb,
                .foregroundColor: UIColor.primarydark,
            ])
            .style(to: "/4", attributes: [
                .font: UIFont.iosBody17Sb,
                .foregroundColor: UIColor.darkG35,
            ])
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel = UILabel().then { label in
        var font = UIFont.aggroLight.withSize(26)
        label.font = font
        label.setTextWithLineHeight(text: L10n.Onboarding.Job.title, with: 42)
        label.textColor = .primary
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var subTitleLabel = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.Onboarding.Job.subTitle
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

//    private var jobLabels = Job.allCases.reduce(into: [OnOffLabel]()) { partialResult, job in
//        if job != .none {
//            partialResult.append(OnOffLabel(text: job.emoji + " " + job.name))
//        }
//    }
//
//    private var jobGroup = OnOffLabelGroup().then { group in
//        group.styleOn = OnOffLabel.Style(
//            font: .iosBody15B,
//            backgroundColor: .primary,
//            textColor: .darkG6,
//            borderWidth: 1,
//            borderColor: .primary,
//            cornerRadiusRatio: 1,
//            useCornerRadiusAsFactor: true,
//            padding: UIEdgeInsets(top: 8, left: 19, bottom: 10, right: 19)
//        )
//
//        group.styleOff = OnOffLabel.Style(
//            font: .iosBody15R,
//            backgroundColor: .clear,
//            textColor: .darkG35,
//            borderWidth: 1,
//            borderColor: .darkG35,
//            cornerRadiusRatio: 1,
//            useCornerRadiusAsFactor: true,
//            padding: UIEdgeInsets(top: 8, left: 19, bottom: 10, right: 19)
//        )
//
//        group.maxNumberOfOnState = 1
//    }
//
//    var jobGroupCollectionView: UICollectionView = {
//        var layout = JobGroupCollectionViewLayout()
//        layout.xSpacing = 12
//        layout.ySpacing = 16
//        layout.estimatedItemSize = CGSize(width: 140, height: 40)
//        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(JobGroupCollectionViewCell.self, forCellWithReuseIdentifier: JobGroupCollectionViewCell.id)
//        collectionView.backgroundColor = .clear
//        return collectionView
//    }()
    var jobGroupView = JobGroupView()

    private var completeButton = UIButton().then { button in
        button.setTitle(L10n.Onboarding.Job.Button.Next.title, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.Onboarding.Job.Button.Next.title, for: .disabled)
        button.setTitleColor(UIColor.darkG4, for: .disabled)
        button.setBackgroundColor(UIColor.darkG5, for: .disabled)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true

        button.isEnabled = false
    }
}

// MARK: - Layout

extension SelectJobGroupViewController {
    private func setupViews() {
        view.backgroundColor = .darkG7

        view.addSubviews([
            navBar,
            titleLabel,
            subTitleLabel,
            jobGroupView,
            completeButton,
        ])

//        jobGroup.append(labels: jobLabels)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(view.snp.leading).offset(18)
            make.trailing.equalTo(view.snp.trailing).offset(-137)
        }

        jobGroupView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(80)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(340)
            make.height.equalTo(276)
        }

        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        completeButton.layer.cornerRadius = 24
    }
}
