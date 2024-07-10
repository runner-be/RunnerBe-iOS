//
//  MessageRoomViewController.swift
//  Runner-be
//
//  Created by 이유리 on 2022/04/26.
//

import Photos
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MessageRoomViewController: BaseViewController {
    let formatter = DateUtil.shared.dateFormatter
    let dateUtil = DateUtil.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInputs()
        viewModelInput()
        viewModelOutput()

        formatter.dateFormat = DateFormat.apiDate.formatString

//        messageInputView.delegate = self
        dismissKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    init(viewModel: MessageRoomViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageRoomViewModel

    private func viewInputs() { // 얘는 이벤트가 들어오되 뷰모델을 거치지 않아도 되는애들
        viewModel.routeInputs.needUpdate.onNext(true)

        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.report)
            .disposed(by: disposeBag)

        postSection.rx.tapGesture()
            .when(.recognized)
            .map { _ in self.viewModel.roomInfo?.postId ?? -1 }
            .bind(to: viewModel.inputs.detailPost)
            .disposed(by: disposeBag)

        messageInputView.sendButtonTapped
            .bind(to: viewModel.inputs.sendMessage)
            .disposed(by: disposeBag)

        messageInputView.plusImageButtonTapped
            .bind(to: viewModel.inputs.tapPostImage)
            .disposed(by: disposeBag)
    }

    private func viewModelInput() { // 얘는 이벤트가 뷰모델로 전달이 되어야할 때 쓰는 애들
        messageInputView.imageSelectedSubjectoutput
            .bind(to: viewModel.inputs.deleteImage)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() { // 뷰모델에서 뷰로 데이터가 전달되어 뷰의 변화가 반영되는 부분
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.roomInfo
            .subscribe(onNext: { roomInfo in
                self.postSection.badgeLabel.setTitle(roomInfo.runningTag, for: .normal)
                self.postSection.postTitle.text = roomInfo.title
            })
            .disposed(by: disposeBag)

        viewModel.outputs.successSendMessage
            .bind(to: messageInputView.messageSendStatusSubject)
            .disposed(by: disposeBag)

        viewModel.outputs.messageContents
            .filter { [weak self] contents in
                if contents.isEmpty {
                    self!.messageContentsTableView.isHidden = true
                    return false
                } else {
                    self!.messageContentsTableView.isHidden = false
                    return true
                }
            }
            .bind(to: messageContentsTableView.rx.items) { _, _, item -> UITableViewCell in

                let date = self.dateUtil.apiDateStringToDate(item.createdAt!)

                if item.messageFrom == "Others" {
                    let cell = self.messageContentsTableView.dequeueReusableCell(withIdentifier: MessageChatLeftCell.id) as! MessageChatLeftCell

                    cell.configure(
                        text: item.content,
                        nickname: item.nickName,
                        date: date,
                        imageUrls: [item.imageUrl] // TODO: 서버로부터 받아오는 URL을 사용
                    )

                    return cell

                } else {
                    let cell = self.messageContentsTableView.dequeueReusableCell(withIdentifier: MessageChatRightCell.id) as! MessageChatRightCell

                    cell.configure(
                        text: item.content,
                        date: date,
                        imageUrls: [item.imageUrl] // TODO: 서버로부터 받아오는 URL을 사용
                    )

                    return cell
                }
            }
            .disposed(by: disposeBag)

        viewModel.outputs.messageContents
            .filter { !$0.isEmpty }
            .subscribe(onNext: { messages in
                self.messageContentsTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true) // 맨 마지막 내용으로 이동하도록
            })
            .disposed(by: disposeBag)

        viewModel.outputs.showPicker
            .subscribe(onNext: { [weak self] sourceType in
                guard let self = self else { return }
                let picker = UIImagePickerController()
                picker.delegate = self

                switch sourceType {
                case .library: // 갤러리
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
                case .camera: // 카메라
                    picker.sourceType = UIImagePickerController.SourceType.camera
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { ok in
                        DispatchQueue.main.async {
                            if ok {
                                AppContext.shared.rootNavigationController?.present(picker, animated: true)
                            } else {
                                AppContext.shared.makeToast("설정화면에서 카메라 접근권한을 설정해주세요")
                            }
                        }
                    })
                }
            })
            .disposed(by: disposeBag)
        //            messageInputView.imageSubject.onNext([image])
        viewModel.outputs.selectedImages
            .bind(to: messageInputView.imageSelectedSubject)
            .disposed(by: disposeBag)

        messageInputView.imageSelectedSubject
            .bind { [weak self] index in
                print("eje0jf9e0wjf \(index)")
            }.disposed(by: disposeBag)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.backgroundColor = .darkG7
        navBar.titleLabel.text = L10n.MessageList.NavBar.title
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = false
        navBar.rightBtnItem.setImage(Asset.iconsReport24.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    var postSection = MessagePostView().then { view in
        view.badgeLabel.titleLabel?.text = "태그"
        view.postTitle.text = "게시글 제목"
    }

    private var messageContentsTableView = UITableView().then { view in
        view.register(MessageChatLeftCell.self, forCellReuseIdentifier: MessageChatLeftCell.id) // 케이스에 따른 셀을 모두 등록
        view.register(MessageChatRightCell.self, forCellReuseIdentifier: MessageChatRightCell.id)
        view.backgroundColor = .darkG7
        view.separatorColor = .clear
    }

    var chatBackGround = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private let messageInputView = MessageInputView().then {
        // TODO: 색상코드이름
        $0.backgroundColor = UIColor(white: 29.0 / 255.0, alpha: 1.0)
        $0.cornerRadius = 19
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        $0.placeHolder = L10n.MessageList.Chat.placeHolder

        $0.font = .pretendardRegular14
        $0.textColor = .darkG35
    }
}

// MARK: - Layout

extension MessageRoomViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            postSection,
            messageContentsTableView,
            messageInputView,
        ])

        view.bringSubviewToFront(navBar)
        view.bringSubviewToFront(postSection)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        postSection.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }

        messageContentsTableView.snp.makeConstraints { make in
            make.top.equalTo(postSection.snp.bottom).offset(10) // postSection만큼 떨어뜨리기
            make.leading.equalTo(self.view.snp.leading).offset(16)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
            make.bottom.equalTo(self.messageInputView.snp.top)
        }

        messageInputView.snp.makeConstraints {
            $0.top.equalTo(messageContentsTableView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.3) {
                self.messageInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardRectangle.height)
                }
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc
    func keyboardWillHide(_: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.messageInputView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(0)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension MessageRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let originalImage = info[.originalImage] as? UIImage
        let originalResizedImage = originalImage?.resize(newWidth: 300)

        if let image = originalResizedImage,
           let imageData = image.pngData()
        {
            viewModel.inputs.selectImage.onNext(image)
        } else {
            AppContext.shared.makeToast("오류가 발생했습니다. 다시 시도해주세요")
        }

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
