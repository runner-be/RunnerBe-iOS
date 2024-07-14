//
//  MessageInputView.swift
//  Runner-be
//
//  Created by 김창규 on 6/29/24.
//

import RxSwift
import SnapKit
import UIKit

// TODO: 외부에서 인터페스 사용하도록 리팩토링
final class MessageInputView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        processingInputs()
        textView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties

    private let disposeBag = DisposeBag()

    private let sendButtonTappedSubject = PublishSubject<String?>()
    var sendButtonTapped: Observable<String?> {
        return sendButtonTappedSubject.asObservable()
    }

    private let plusImageButtonTappedSubject = PublishSubject<Void>()
    var plusImageButtonTapped: Observable<Void> {
        return plusImageButtonTappedSubject.asObservable()
    }

    var messageSendStatusSubject = PublishSubject<Bool>()

    var imageSelectedSubject = PublishSubject<[UIImage]>()
    var imageSelectedSubjectoutput = PublishSubject<Int>()

    var placeHolder: String = "" {
        didSet {
            textView.text = placeHolder
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            textContainerView.layer.cornerRadius = cornerRadius
        }
    }

    var textColor: UIColor = .white {
        didSet {
            textView.textColor = textColor
        }
    }

    var font: UIFont? {
        didSet {
            textView.font = font
        }
    }

    var textContainerInset: UIEdgeInsets? {
        didSet {
            if let textContainerInset = textContainerInset {
                textView.textContainerInset = textContainerInset
            }
        }
    }

    var isTextEmpty: Bool = true

    // MARK: - UI

    private var imageContainerHeightConstraint: Constraint?

    private let contentView = UIView()

    private let textContainerView = UIView().then {
        // TODO: 색상코드이름
        $0.backgroundColor = UIColor(white: 41.0 / 255.0, alpha: 1.0)
    }

    private let imageContainerView = UIView().then {
        $0.backgroundColor = .darkG7
//        $0.isHidden = true
    }

    private let lineView = UIView().then {
        $0.backgroundColor = .darkG6
    }

    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.register(
            MessageSelectedImageCell.self,
            forCellWithReuseIdentifier: MessageSelectedImageCell.id
        )
        collectionView.backgroundColor = .darkG7
        return collectionView
    }()

    private let textView = UITextView().then {
        $0.backgroundColor = .clear
    }

    private var sendButton = UIButton().then {
        $0.isEnabled = false
        $0.setImage(Asset.iconsSend24.uiImage, for: .disabled)
        $0.setImage(Asset.iconsSendFilled24.uiImage, for: .normal)
    }

    private var plusImageButton = UIButton().then {
        $0.setImage(Asset.iconsPlus18.uiImage, for: .normal)
    }

    override func layoutSubviews() {
        textView.centerVertically()
    }

    private func processingInputs() {
        imageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        sendButton.rx.tap
            .map {
                if self.textView.text != "" && !self.isTextEmpty {
                    return self.textView.text
                } else {
                    return nil
                }
            }
            .bind(to: sendButtonTappedSubject)
            .disposed(by: disposeBag)

        plusImageButton.rx.tap
            .bind(to: plusImageButtonTappedSubject)
            .disposed(by: disposeBag)

        messageSendStatusSubject
            .filter { $0 }
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.textView.text.removeAll()
                self.textViewDidChange(self.textView)
                self.textViewDidEndEditing(self.textView)
                self.textView.resignFirstResponder()
                self.imageSelectedSubject.onNext([])
            }.disposed(by: disposeBag)

        imageSelectedSubject
            .filter { [weak self] images in
                guard let self = self else { return false }
                if images.isEmpty {
                    self.imageContainerHeightConstraint?.update(offset: 0)
                    self.sendButton.isEnabled = !isTextEmpty
                    return false
                } else {
                    self.imageContainerHeightConstraint?.update(offset: 80 + 32 + 1)
                    self.sendButton.isEnabled = true
                    return true
                }
            }
            .bind(to: imageCollectionView.rx.items(
                cellIdentifier: MessageSelectedImageCell.id,
                cellType: MessageSelectedImageCell.self
            )) { index, image, cell in

                cell.configure(
                    image: image,
                    tag: index
                )

                cell.cancleButton.rx.tapGesture()
                    .when(.recognized)
                    .map { _ in cell.tag }
                    .bind { index in
                        self.imageSelectedSubjectoutput.onNext(index)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView Delegate

extension MessageInputView: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

// MARK: - TextView Delegate

extension MessageInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .darkG1
            isTextEmpty = false
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = .darkG5
            isTextEmpty = true
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let numberOfLine = textView.numberOfLines()
        sendButton.isEnabled = !textView.text.isEmpty || (!imageCollectionView.visibleCells.isEmpty)

        if numberOfLine >= 3 {
            return
        }

        let verticalPadding = textView.textContainer.lineFragmentPadding
        let addHeight = CGFloat(numberOfLine - 1) * ((textView.font?.lineHeight ?? 0) - verticalPadding)

        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0

        // Update textView's height
        contentView.snp.updateConstraints {
            $0.top.equalTo(imageContainerView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(38 + bottomPadding + addHeight) // TODO: safeArea bottom height
        }

        textContainerView.layer.cornerRadius = numberOfLine >= 2 ? 12 : 19
        textView.snp.updateConstraints {
            $0.height.equalTo(22 + addHeight)
        }

        // Animate layout changes
        UIView.animate(withDuration: 0.2) {
            self.superview?.layoutIfNeeded()
        }
    }
}

// MARK: - Layout

extension MessageInputView {
    private func setupViews() {
        addSubviews([
            contentView,
            imageContainerView,
        ])

        imageContainerView.addSubviews([
            imageCollectionView,
            lineView,
        ])

        contentView.addSubviews([
            plusImageButton,
            textContainerView,
            sendButton,
        ])

        textContainerView.addSubviews([
            textView,
        ])
    }

    private func initialLayout() {
        imageContainerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            self.imageContainerHeightConstraint = $0.height.equalTo(0).constraint
        }

        lineView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }

        imageCollectionView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
            $0.top.equalTo(imageContainerView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(38 + bottomPadding) // TODO: safeArea bottom height
        }

        plusImageButton.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.centerY.equalTo(textContainerView)
            $0.left.equalToSuperview().inset(12)
        }

        textContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalTo(plusImageButton.snp.right).offset(8)
            $0.right.equalTo(sendButton.snp.left).offset(-8)
        }

        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(22)
            $0.left.right.equalToSuperview().inset(16)
        }

        sendButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(textContainerView)
            $0.right.equalToSuperview().inset(12)
        }
    }
}
