//
//  PostDetailViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

final class PostDetailViewController: BaseViewController, SkeletonDisplayable {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        showSkeleton()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: PostDetailViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.rightOptionItem)
            .disposed(by: disposeBag)

        detailMapView.copyButton.rx.tap
            .bind(to: viewModel.inputs.copyPlaceName)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.detailData
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.navBar.titleLabel.text = data.running.badge
                self.titleView.configure(title: data.postDetail.post.title, runningPace: data.postDetail.post.pace, isFinished: data.finished)
                self.infoView.setup(
                    date: data.running.date,
                    afterParty: data.running.afterParty,
                    time: data.running.time,
                    numLimit: data.running.numParticipant,
                    gender: data.running.gender,
                    age: data.running.age
                )
                self.textView.text = data.running.contents
                self.detailMapView.setup(
                    lat: data.running.lat,
                    long: data.running.long,
                    range: data.participated ? data.running.range / 3 : data.running.range,
                    showMarker: data.participated,
                    placeName: data.running.placeName,
                    placeExplain: data.running.placeExplain
                )

                let userInfoViews = data.participants.reduce(into: [UIView]()) {
                    let view = UserInfoWithSingleDivider()
                    let userId = $1.userId

                    view.setup(userInfo: $1)
                    $0.append(view)

                    view.userInfoView.avatarView.rx.tapGesture()
                        .when(.recognized)
                        .map { _ in userId }
                        .bind(to: self.viewModel.inputs.tapProfile)
                        .disposed(by: self.disposeBag)
                }

                self.participantHeader.numLabel.text = "(\(userInfoViews.count)/\(data.postDetail.maximumNum))"
                self.participantView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                self.participantView.addArrangedSubviews(userInfoViews)
                self.makeNavBarRightButton(writer: data.writer)
                self.makeFooter(
                    writer: data.writer,
                    participated: data.participated,
                    applied: data.applied,
                    satisfied: data.satisfied,
                    finished: data.finished
                )
                self.applicantNoti.isHidden = data.numApplicant == 0

                self.hideSkeleton()
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var titleView = DetailTitleView()
    private var hDivider1 = UIView().then { view in
        view.backgroundColor = .darkG55
    }

    private var infoView = DetailInfoView()
    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG55
    }

    private var textView = UITextView().then { view in
        view.font = .iosBody15R
        view.textColor = .darkG25
        view.text = "게시글\n상세\n내용"
        view.isScrollEnabled = false
        view.isEditable = false
        view.backgroundColor = .clear
    }

    private var hDivider3 = UIView().then { view in
        view.backgroundColor = .black
    }

    private var detailMapView = DetailMapView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    private lazy var vStackView = UIStackView.make(
        with: [
            titleView,
            hDivider1,
            infoView,
            hDivider2,
            textView,
            detailMapView,
            hDivider3,
        ],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 24
    )

    private var participantHeader = UserInfoHeader()

    private var participantView = UIStackView.make(
        with: [],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 0
    )

    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
    }

    private var footer: PostDetailFooter?

    var applicantBtn = UIButton().then { button in
        button.setImage(Asset.applicant.uiImage, for: .normal)
        button.isHidden = true
        button.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(56)
        }
    }

    var applicantNoti = UIView().then { view in
        view.backgroundColor = .error
        view.clipsToBounds = true
        view.snp.makeConstraints { make in
            make.width.equalTo(14)
            make.height.equalTo(14)
        }
        view.layer.cornerRadius = 7
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = ""
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.report.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension PostDetailViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            scrollView,
            applicantBtn,
        ])

        scrollView.addSubviews([
            vStackView,
            participantHeader,
            participantView,
        ])

        applicantBtn.addSubviews([applicantNoti])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(24)
            make.leading.equalTo(scrollView.snp.leading).offset(16)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-16)
        }

        detailMapView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        hDivider1.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(1)
        }
        hDivider2.snp.makeConstraints { make in
            make.leading.equalTo(vStackView.snp.leading)
            make.trailing.equalTo(vStackView.snp.trailing)
            make.height.equalTo(1)
        }

        hDivider3.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(10)
        }

        participantHeader.snp.makeConstraints { make in
            make.top.equalTo(vStackView.snp.bottom).offset(20)
            make.leading.equalTo(vStackView.snp.leading)
        }

        participantView.snp.makeConstraints { make in
            make.top.equalTo(participantHeader.snp.bottom).offset(4)
            make.leading.equalTo(vStackView.snp.leading)
            make.trailing.equalTo(vStackView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-56)
        }

        applicantNoti.snp.makeConstraints { make in
            make.trailing.equalTo(applicantBtn.snp.trailing)
            make.top.equalTo(applicantBtn.snp.top)
        }
    }

    func makeNavBarRightButton(writer: Bool) {
        if writer {
            navBar.rightBtnItem.setImage(Asset.moreVertical.uiImage, for: .normal)
        } else {
            navBar.rightBtnItem.setImage(Asset.report.uiImage.withTintColor(.darkG3), for: .normal)
        }
    }

    func makeFooter(writer: Bool, participated _: Bool, applied: Bool, satisfied: Bool, finished: Bool) {
        footer?.removeFromSuperview()

        let footer: PostDetailFooter

        if finished {
            let writerFooter = PostWriterFooter()

            writerFooter.applyBtn.isEnabled = false
            writerFooter.toMessageButton.isEnabled = true
            applicantBtn.isHidden = true
            footer = writerFooter
        } else if writer {
            let writerFooter = PostWriterFooter()
            writerFooter.toMessageButton.isEnabled = true

            writerFooter.applyBtn.rx.tap
                .debug()
                .bind(to: viewModel.inputs.finishing)
                .disposed(by: disposeBag)

            applicantBtn.isHidden = false

            applicantBtn.rx.tap
                .debug()
                .bind(to: viewModel.inputs.showApplicant)
                .disposed(by: writerFooter.disposeBag)

            viewModel.outputs.finished
                .subscribe(onNext: { finished in
                    writerFooter.applyBtn.isEnabled = !finished
                })
                .disposed(by: writerFooter.disposeBag)

            footer = writerFooter
        } else {
            let guestFooter = PostGuestFooter(applied: applied, satisfied: satisfied)
            guestFooter.toMessageButton.isEnabled = true

            guestFooter.applyBtn.rx.tap
                .bind(to: viewModel.inputs.apply)
                .disposed(by: guestFooter.disposeBag)

            viewModel.outputs.apply
                .subscribe(onNext: { applied in
                    guestFooter.applyBtn.isEnabled = !applied
                })
                .disposed(by: guestFooter.disposeBag)

            footer = guestFooter
        }

        footer.toMessageButton.rx.tap
            .bind(to: viewModel.inputs.toMessage)
            .disposed(by: footer.disposeBag)

        view.addSubviews([footer])

        footer.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        let safeAreaCover = UIView()
        safeAreaCover.backgroundColor = footer.backgroundColor
        view.addSubviews([safeAreaCover])
        safeAreaCover.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(footer.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }

        if writer {
            applicantBtn.snp.makeConstraints { make in
                make.trailing.equalTo(view.snp.trailing).offset(-16)
                make.bottom.equalTo(footer.snp.top).offset(-15)
            }
        }
        self.footer = footer
    }
}
