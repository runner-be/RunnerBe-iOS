//
//  LicenseDetailController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//
//
// AcknowViewController.swift
//
// Copyright (c) 2015-2022 Vincent Tourraine (https://www.vtourraine.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if os(iOS) || os(tvOS)
    import AcknowList
    import RxCocoa
    import RxSwift
    import SnapKit
    import Then
    import UIKit

    /// Subclass of `UIViewController` that displays a single acknowledgement.
    @available(iOS 9.0.0, tvOS 9.0.0, *)
    open class LicenseDetailController: UIViewController {
        var textView = UITextView()

        var navBar = RunnerbeNavBar().then { navBar in
            navBar.backgroundColor = .bgTop
            navBar.titleLabel.textColor = .darkG35
            navBar.titleLabel.font = .iosBody17Sb
            navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
            navBar.rightBtnItem.isHidden = true
            navBar.rightSecondBtnItem.isHidden = true
        }

        let sceneDisposeBag = DisposeBag()

        /// The represented acknowledgement.
        var acknowledgement: Acknow?

        public init(acknowledgement: Acknow) {
            super.init(nibName: nil, bundle: nil)
            navBar.titleLabel.text = acknowledgement.title
            title = acknowledgement.title
            self.acknowledgement = acknowledgement
        }

        /**
         Initializes the `AcknowViewController` instance with a coder.

         - parameter aDecoder: The archive coder.

         - returns: The new `AcknowViewController` instance.
         */
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        // MARK: - View lifecycle

        /// Called after the controller's view is loaded into memory.
        override open func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .bgTop
            textView.backgroundColor = .darkG55
            textView.textColor = .darkG3
            view.addSubview(navBar)
            view.addSubview(textView)
            textView.isEditable = false

            navBar.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide
                    .snp.top)
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
            }

            textView.snp.makeConstraints { make in
                make.top.equalTo(navBar.snp.bottom).offset(5)
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }

            navBar.leftBtnItem.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
                .disposed(by: sceneDisposeBag)
        }

        /// Called to notify the view controller that its view has just laid out its subviews.
        override open func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            // Need to set the textView text after the layout is completed, so that the content inset and offset properties can be adjusted automatically.
            if let acknowledgement = acknowledgement {
                textView.text = acknowledgement.text
            }
        }

        override open var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
    }

#endif
