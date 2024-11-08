//
//  MyPageViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//
import Photos
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

final class MyPageViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInputs()
    }

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MyPageViewModel

    private func viewModelInput() {
        viewModel.routeInputs.needUpdate.onNext(true)
        myProfileView.editProfileLabel.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.editInfo)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.settings)
            .disposed(by: disposeBag)

        myProfileView.avatarView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.changePhoto)
            .disposed(by: disposeBag)

        myLogStampView.titleIcon.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.tapLogStampIcon)
            .disposed(by: disposeBag)

        myLogStampView.logStampCollectionView.rx.itemSelected
            .map { $0 }
            .bind(to: viewModel.inputs.tapLogStamp)
            .disposed(by: disposeBag)

        myPostHeaderView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.tapMyRunning)
            .disposed(by: disposeBag)

        myRunningCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBag)

        myPostEmptyButton.rx.tap
            .bind(to: viewModel.inputs.writePost)
            .disposed(by: disposeBag)

        myRunningEmptyButton.rx.tap
            .bind(to: viewModel.inputs.toMain)
            .disposed(by: disposeBag)

        myProfileView.myInfoView.registerPaceView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.registerRunningPace)
            .disposed(by: disposeBag)

        myProfileView.myInfoView.editPaceLabel.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.registerRunningPace)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        myRunningCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        myLogStampView.logStampCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        // 나의 로그 스탬프
        typealias MyLogStampDataSource = RxCollectionViewSectionedReloadDataSource<MyLogStampSection>

        let myLogStampDatasource = MyLogStampDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let _ = self,
                      let cell = collectionView.dequeueReusableCell(
                          withReuseIdentifier: MyLogStampCell.id,
                          for: indexPath
                      ) as? MyLogStampCell
                else {
                    return UICollectionViewCell()
                }

                cell.configure(with: LogStamp(
                    logId: nil,
                    gatheringId: nil,
                    date: element.date,
                    stampType: element.stampType,
                    isOpened: element.isOpened,
                    isGathering: element.isGathering
                ))

                return cell
            }
        )

        viewModel.outputs.days
            .debug("logStamps")
            .map { [MyLogStampSection(items: $0)] }
            .bind(to: myLogStampView.logStampCollectionView.rx.items(dataSource: myLogStampDatasource))
            .disposed(by: disposeBag)

        // 작성한 글 탭
        typealias MyPagePostDataSource
            = RxCollectionViewSectionedAnimatedDataSource<MyPagePostSection>

        viewModel.outputs.days
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
//FIXME: 3번째 페이지부터 시작하도록 스크롤을 옮겨야하는데 에러남
//                // 콜렉션 뷰가 리로드된 후 특정 아이템으로 스크롤
//                self.myLogStampView.logStampCollectionView.scrollToItem(
//                    at: IndexPath(
//                        item: 0,
//                        section: self.myLogStampView.pageControl.currentPage
//                    ),
//                    at: .left,
//                    animated: false
//                )
            })
            .disposed(by: disposeBag)

        viewModel.outputs.logTotalCount
            .bind { [weak self] logTotalCount in
                self?.myLogStampView.updateCountLabel(with: logTotalCount)
            }
            .disposed(by: disposeBag)

        let myRunningDatasource = MyPagePostDataSource { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageParticipateCell.id, for: indexPath) as? MyPageParticipateCell
            else { return UICollectionViewCell() }

            cell.configure(with: item)

            cell.postInfoView.bookMarkIcon.rx.tap
                .map { indexPath.item }
                .subscribe(onNext: { [weak self] index in
                    self?.viewModel.inputs.bookMark.onNext(index)
                }).disposed(by: cell.disposeBag)

            cell.manageAttendanceButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapManageAttendance)
                .disposed(by: cell.disposeBag)

            cell.confirmAttendanceButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapConfirmAttendance)
                .disposed(by: cell.disposeBag)

            cell.writeLogButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapWriteLog)
                .disposed(by: cell.disposeBag)

            cell.confirmLogButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapConfirmLog)
                .disposed(by: cell.disposeBag)
            return cell
        }

        viewModel.outputs.posts
            .filter { [unowned self] _ in self.viewModel.outputs.postType == .attendable }
            .map { [MyPagePostSection(items: $0)] }
            .bind(to: myRunningCollectionView.rx.items(dataSource: myRunningDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.posts
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] empty in
                guard let self = self else { return }
                self.myRunningCollectionView.isHidden = false
                self.myRunningEmptyLabel.isHidden = !empty
                self.myRunningEmptyButton.isHidden = !empty
            })
            .disposed(by: disposeBag)

        viewModel.outputs.userInfo
            .subscribe(onNext: { [weak self] config in
                self?.myProfileView.configure(with: config)
                self?.myProfileView.myInfoView.isHidden = false
                if config.pace == nil {
                    self?.registerPaceWordBubble.isHidden = false
                } else {
                    self?.registerPaceWordBubble.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                self.view.makeToast(message, point: CGPoint(x: self.view.frame.center.x, y: self.view.frame.maxY - 50), title: nil, image: nil, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.showPicker
            .map { $0.sourceType }
            .subscribe(onNext: { [weak self] sourceType in
                guard let self = self else { return }
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                switch sourceType {
                case "library": // 갤러리
                    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    PHPhotoLibrary.requestAuthorization { [weak self] status in
                        DispatchQueue.main.async {
                            switch status {
                            case .authorized:
                                self?.present(picker, animated: true)
                            default:
                                AppContext.shared.makeToast("설정화면에서 앨범 접근권한을 설정해주세요")
                            }
                        }
                    }
                case "camera": // 카메라
                    picker.sourceType = UIImagePickerController.SourceType.camera
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] ok in
                        DispatchQueue.main.async {
                            if ok {
                                AppContext.shared.rootNavigationController?.present(picker, animated: true)
                            } else {
                                AppContext.shared.makeToast("설정화면에서 카메라 접근권한을 설정해주세요")
                            }
                        }
                    })
                default: // 기본 이미지로 변경
                    self.myProfileView.avatarView.image = Asset.iconsProfile48.uiImage
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.profileChanged
            .subscribe(onNext: { [weak self] data in
                if let data = data {
                    self?.myProfileView.avatarView.image = UIImage(data: data)
                } else {
                    self?.myProfileView.avatarView.image = Asset.profileEmptyIcon.uiImage
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.changeTargetDate
            .map { "\($0.year)년 \($0.month)월" }
            .bind(to: myLogStampView.dateLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func viewInputs() {}

    private var scrollView = UIScrollView(frame: .zero).then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    private var myProfileView = MyProfileView().then { view in
        view.myInfoView.isHidden = true
    }

    private var registerPaceWordBubble = UIImageView().then { view in
        view.image = Asset.myPageRegistserRunningPaceWordbubble.uiImage
        view.snp.makeConstraints { make in
            make.width.equalTo(124)
            make.height.equalTo(48)
        }
        let label = UILabel()
        label.text = "페이스를 등록하세요!"
        label.textColor = .primary
        label.font = .pretendardRegular12
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(12)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }

        view.isHidden = true
    }

    private let myLogStampView = MyLogStampView().then {
        $0.pageControl.currentPage = 2
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .orange
        view.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
    }

    // TODO: - CollectionView의 HeadrView로 변경
    private let myPostHeaderView = UIView()
    private let myPostHeaderTitle = UILabel().then {
        $0.text = "참여한 러닝"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let myPostHeaderIcon = UIImageView().then {
        $0.image = Asset.chevronRight.uiImage
    }

    private lazy var myRunningCollectionView: UICollectionView = { // 참여 러닝 탭
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPageParticipateCell.self, forCellWithReuseIdentifier: MyPageParticipateCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = false
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private var myPostEmptyLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG45
        label.isHidden = true
        label.text = L10n.MyPage.MyPost.Empty.title
    }

    private var myPostEmptyButton = UIButton().then { button in
        button.sizeToFit()
        button.setTitle(L10n.MyPage.MyPost.Empty.Button.title, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 10, right: 20)
        button.setTitleColor(.primary, for: .normal)
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
    }

    private var myRunningEmptyLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG45
        label.isHidden = true
        label.text = L10n.MyPage.MyRunning.Empty.title
    }

    private var myRunningEmptyButton = UIButton().then { button in
        button.sizeToFit()
        button.setTitle(L10n.MyPage.MyRunning.Empty.Button.title, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 10, right: 20)
        button.setTitleColor(.primary, for: .normal)
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "프로필"
        navBar.rightBtnItem.setImage(Asset.settings.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension MyPageViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            scrollView,
        ])

        scrollView.addSubview(contentView)

        contentView.addSubviews([
            myProfileView,
            registerPaceWordBubble,
            myLogStampView,
            hDivider,
            myPostHeaderView,
            myRunningCollectionView,
        ])

        myPostHeaderView.addSubviews([
            myPostHeaderTitle,
            myPostHeaderIcon,
        ])

        contentView.bringSubviewToFront(registerPaceWordBubble)

        myRunningCollectionView.addSubviews([
            myRunningEmptyLabel,
            myRunningEmptyButton,
        ])
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
            make.bottom.equalTo(view.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height).priority(.low)
        }

        myProfileView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        registerPaceWordBubble.snp.makeConstraints { make in
            make.bottom.equalTo(myProfileView.myInfoView.snp.top).offset(12)
            make.leading.equalTo(myProfileView.myInfoView.snp.leading).offset(13)
        }

        myLogStampView.snp.makeConstraints {
            $0.top.equalTo(myProfileView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
        }

        myPostHeaderView.snp.makeConstraints {
            $0.top.equalTo(myLogStampView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }

        myPostHeaderTitle.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
        }

        myPostHeaderIcon.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.size.equalTo(24)
        }

        myRunningCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myPostHeaderView.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
            make.height.equalTo(208)
        }

        myRunningEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(myRunningCollectionView.snp.centerX)
            make.bottom.equalTo(myRunningCollectionView.snp.centerY).inset(12)
        }

        myRunningEmptyButton.snp.makeConstraints { make in
            make.centerX.equalTo(myRunningCollectionView.snp.centerX)
            make.top.equalTo(myRunningCollectionView.snp.centerY).offset(12)
            make.width.equalTo(190)
            make.height.equalTo(40)
        }
        myRunningEmptyButton.layer.cornerRadius = 20
    }
}

// MARK: - UIImagePickerViewController Delegate

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let originalImage = info[.originalImage] as? UIImage
        let editedImage = info[.editedImage] as? UIImage
        let editedResizedImage = editedImage?.resize(newWidth: 300)
        let originalResizedImage = originalImage?.resize(newWidth: 300)
        viewModel.inputs.photoSelected.onNext(editedResizedImage?.pngData() ?? originalResizedImage?.pngData())
        picker.dismiss(animated: true)
    }

    func photoAuth() -> Bool {
        let authorizationState = PHPhotoLibrary.authorizationStatus()
        var isAuth = false

        switch authorizationState {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted:
            break
        case .denied:
            break
        case .limited:
            break
        @unknown default:
            break
        }
        return false
    }

    func cameraAuth() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }

    func authSettingOpen(authString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(authString) 접근 허용이 되어있지 않습니다. \r\n 설정화면으로 가시겠습니까?"
            let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)

            let cancel = UIAlertAction(title: "취소", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
                print("\(String(describing: action.title)) 클릭")
            }

            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }

            alert.addAction(cancel)
            alert.addAction(confirm)

            present(alert, animated: true, completion: nil)
        }
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        switch collectionView {
        case let c where c == myRunningCollectionView:
            return MyPageParticipateCell.size
        case let c where c == myLogStampView.logStampCollectionView:
            return MyLogStampCell.size
        default:
            return .zero
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch scrollView {
        case myRunningCollectionView:
            return
        case myLogStampView.logStampCollectionView:
            let estimatedIndex = targetContentOffset.pointee.x / myLogStampView.logStampCollectionView.bounds.width
            let index: CGFloat

            index = round(estimatedIndex)
            let offsetX = CGFloat(index) * myLogStampView.logStampCollectionView.bounds.width - 32
            targetContentOffset.pointee = CGPoint(x: offsetX, y: 0)
            myLogStampView.pageControl.currentPage = Int(index)
        default:
            return
        }
    }
}
