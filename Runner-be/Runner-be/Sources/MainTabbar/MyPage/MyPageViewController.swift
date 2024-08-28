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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myLogStampView.logStampCollectionView.scrollToItem(
            at: IndexPath(item: 0, section: 2),
            at: .left,
            animated: false
        )
        myLogStampView.pageControl.currentPage = 2
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
        writtenTab.rx.tap
            .map { MyPageViewModel.PostType.myPost }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBag) // disposebag에 여러개의 구독을 담아두고, disposebag이 해제되면 모두 해제됨

        participantTab.rx.tap
            .map { MyPageViewModel.PostType.attendable }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBag)

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

        myLogStampView.logStampCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapLogStamp)
            .disposed(by: disposeBag)

        myPostCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
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
        myPostCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        myRunningCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        myLogStampView.logStampCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        // 나의 로그 스탬프
        typealias MyLogStampDataSource = RxCollectionViewSectionedAnimatedDataSource<MyLogStampSection>

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

                cell.configure(
                    dayOfWeek: element.dayOfWeek,
                    date: element.date
                )

                return cell
            }
        )

        // 작성한 글 탭
        typealias MyPagePostDataSource
            = RxCollectionViewSectionedAnimatedDataSource<MyPagePostSection>

        let myPostDatasource = MyPagePostDataSource { [self] _, collectionView, indexPath, item in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPagePostCell.id, for: indexPath) as? MyPagePostCell
            else { return UICollectionViewCell() }
            cell.configure(with: item)
            cell.postInfoView.bookMarkIcon.isHidden = true
            cell.manageButton.rx.tap // 해당 코드가 여러 셀에게 인식이 되어 무관한 화면까지 이동하여 순서가 안맞는것처럼 보이는것같음.
                .map { _ in
                    indexPath.row
                }
                .bind(to: self.viewModel.inputs.manageAttendance) // indexPath.row 넘겨주기 -> 작성한 글 인덱스
                .disposed(by: cell.disposeBag) // button이 여러번 눌리는 현상 : cell의 disposeBag을 사용하여 Dispose해야함.

            return cell
        }

        viewModel.outputs.logStamps
            .debug("logStamps")
            .bind(to: myLogStampView.logStampCollectionView.rx.items(dataSource: myLogStampDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.posts
            .filter { [unowned self] _ in self.viewModel.outputs.postType == .myPost }
            .map { [MyPagePostSection(items: $0)] }
            .bind(to: myPostCollectionView.rx.items(dataSource: myPostDatasource))
            .disposed(by: disposeBag)

        let myRunningDatasource = MyPagePostDataSource { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageParticipateCell.id, for: indexPath) as? MyPageParticipateCell
            else { return UICollectionViewCell() }

            cell.configure(with: item)

            cell.postInfoView.bookMarkIcon.isHidden = true

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
                let type = self.viewModel.outputs.postType

                switch type {
                case .myPost:
                    self.myRunningCollectionView.isHidden = true
                    self.myPostCollectionView.isHidden = false

                    self.myPostEmptyLabel.isHidden = !empty
                    self.myPostEmptyButton.isHidden = !empty

                    if !empty {
                        self.myPostCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.myPostCollectionView.contentSize.height)
                        }
                        self.myRunningCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.myPostCollectionView.contentSize.height)
                        }
                    } else {
                        self.myPostCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.view.frame.height - 330)
                        }
                        self.myRunningCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.view.frame.height - 330)
                        }
                    }
                case .attendable:
                    self.myPostCollectionView.isHidden = true
                    self.myRunningCollectionView.isHidden = false

                    self.myRunningEmptyLabel.isHidden = !empty
                    self.myRunningEmptyButton.isHidden = !empty

                    self.myRunningCollectionView.layoutIfNeeded() // contentSize가 0인 경우에 대응 (cell layout을 그리는 시점)

                    if !empty {
                        self.myPostCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.myRunningCollectionView.contentSize.height)
                        }
                        self.myRunningCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.myRunningCollectionView.contentSize.height)
                        }
                    } else {
                        self.myPostCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.view.frame.height - 330) // tabHeight + 컬렉션뷰 위까지의 길이를 계산한 값
                        }
                        self.myRunningCollectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.view.frame.height - 330)
                        }
                    }
                }

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
    }

    private func viewInputs() {
        writtenTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.writtenTab.isSelected = true
                self.tabMover.snp.removeConstraints()
                self.tabMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(tabDivider.snp.bottom)
                    make.leading.equalTo(writtenTab.snp.leading)
                    make.trailing.equalTo(writtenTab.snp.trailing)
                }
                self.participantTab.isSelected = false
            })
            .disposed(by: disposeBag)

        participantTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.participantTab.isSelected = true
                self.tabMover.snp.removeConstraints()
                self.tabMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(tabDivider.snp.bottom)
                    make.leading.equalTo(participantTab.snp.leading)
                    make.trailing.equalTo(participantTab.snp.trailing)
                }
                self.writtenTab.isSelected = false
            })
            .disposed(by: disposeBag)
    }

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

    private let myLogStampView = MyLogStampView()

    private var hDivider = UIView().then { view in
        view.backgroundColor = .black
        view.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
    }

    private var writtenTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .selected)
        button.setTitleColor(.darkG2, for: .selected)
        button.setBackgroundColor(.clear, for: .selected)
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .normal)
        button.setTitleColor(.darkG45, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17Sb
    }

    private var participantTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .selected)
        button.setTitleColor(.darkG2, for: .selected)
        button.setBackgroundColor(.clear, for: .selected)
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .normal)
        button.setTitleColor(.darkG45, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17Sb
    }

    private var tabDivider = UIView().then { view in
        view.backgroundColor = .darkG55
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var tabMover = UIView().then { view in
        view.backgroundColor = .darkG25
        view.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }

    private lazy var myPostCollectionView: UICollectionView = { // 작성 글 탭
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPagePostCell.self, forCellWithReuseIdentifier: MyPagePostCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private lazy var myRunningCollectionView: UICollectionView = { // 참여 러닝 탭
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPageParticipateCell.self, forCellWithReuseIdentifier: MyPageParticipateCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        collectionView.isScrollEnabled = false
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
            writtenTab,
            participantTab,
            tabDivider,
            tabMover,
            myPostCollectionView,
            myRunningCollectionView,
        ])

        contentView.bringSubviewToFront(registerPaceWordBubble)

        myPostCollectionView.addSubviews([
            myPostEmptyLabel,
            myPostEmptyButton,
        ])

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

        writtenTab.snp.makeConstraints { make in
            make.top.equalTo(myLogStampView.snp.bottom).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.centerX)
            make.height.equalTo(28)
        }

        participantTab.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.top)
            make.leading.equalTo(contentView.snp.centerX)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.height.equalTo(28)
        }

        tabDivider.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.bottom).offset(16)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }

        tabMover.snp.makeConstraints { make in
            make.bottom.equalTo(tabDivider.snp.bottom)
            make.leading.equalTo(writtenTab.snp.leading)
            make.trailing.equalTo(contentView.snp.centerX)
        }

        myPostCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tabDivider.snp.bottom).offset(2)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(view.frame.height - 330)
        }

        myRunningCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tabDivider.snp.bottom).offset(2)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(view.frame.height - 330)
        }

        myPostEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(myPostCollectionView.snp.centerX)
            make.bottom.equalTo(myPostCollectionView.snp.centerY).offset(-12)
        }

        myPostEmptyButton.snp.makeConstraints { make in
            make.centerX.equalTo(myPostCollectionView.snp.centerX)
            make.top.equalTo(myPostCollectionView.snp.centerY).offset(12)
            make.width.equalTo(230)
            make.height.equalTo(40)
        }
        myPostEmptyButton.layer.cornerRadius = 20

        myRunningEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(myRunningCollectionView.snp.centerX)
            make.bottom.equalTo(myRunningCollectionView.snp.centerY).offset(-12)
        }

        myRunningEmptyButton.snp.makeConstraints { make in
            make.centerX.equalTo(myRunningCollectionView.snp.centerX)
            make.top.equalTo(myRunningCollectionView.snp.centerY).offset(12)
            make.width.equalTo(190)
            make.height.equalTo(40)
        }
        myRunningEmptyButton.layer.cornerRadius = 20
        writtenTab.isSelected = true
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
        case let c where c == myPostCollectionView:
            return MyPagePostCell.size
        case let c where c == myLogStampView.logStampCollectionView:
            return MyLogStampCell.size
        default:
            return .zero
        }
    }

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let estimatedIndex = targetContentOffset.pointee.x / myLogStampView.logStampCollectionView.bounds.width
        let index: CGFloat

        index = round(estimatedIndex)
        let offsetX = CGFloat(index) * myLogStampView.logStampCollectionView.bounds.width - 32
        targetContentOffset.pointee = CGPoint(x: offsetX, y: 0)
        myLogStampView.pageControl.currentPage = Int(index)
    }
}
