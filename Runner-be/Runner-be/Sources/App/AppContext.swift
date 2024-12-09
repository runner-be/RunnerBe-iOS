//
//  AppContext.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Toast_Swift
import UIKit

class AppContext {
    static let shared = AppContext()
    private init() {}

    var rootNavigationController: UINavigationController?

    var safeAreaInsets: UIEdgeInsets = .zero
    let tabHeight: CGFloat = 52
    let navHeight: CGFloat = 44

    func makeToast(_ message: String?) {
        if let message = message, !message.isEmpty {
            rootNavigationController?.view.hideAllToasts()
            rootNavigationController?.view.makeToast(message)
        }
    }

    func makeToastWithImage(_ message: String?, image: UIImage?) {
        rootNavigationController?.view.hideAllToasts()

        // Create a custom view
        let customView = UIView()
        customView.backgroundColor = UIColor.black
        customView.layer.cornerRadius = 3.5

        // Create and configure an image view
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit

        // Create and configure a label
        let label = UILabel()
        label.font = .pretendardRegular14
        label.textColor = .darkWhite100
        label.numberOfLines = 0
        label.text = message

        customView.addSubviews([imageView, label])

        imageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(12)
            $0.width.height.lessThanOrEqualTo(20)
        }

        label.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(4)
            $0.top.right.bottom.equalToSuperview().inset(12)
        }

        customView.layoutIfNeeded()
        let customViewSize = customView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        customView.frame = CGRect(origin: .zero, size: customViewSize)

        rootNavigationController?.view.showToast(customView, duration: 3.0, position: .bottom)
    }

    func makeToastActivity(position: ToastPosition) {
        rootNavigationController?.view.hideToastActivity()
        rootNavigationController?.view.makeToastActivity(position)
    }

    func hideToastActivity() {
        rootNavigationController?.view.hideToastActivity()
    }

    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
}
