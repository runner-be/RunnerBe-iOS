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

    func makeToastActivity(position: ToastPosition) {
        rootNavigationController?.view.hideToastActivity()
        rootNavigationController?.view.makeToastActivity(position)
    }

    func hideToastActivity() {
        rootNavigationController?.view.hideToastActivity()
    }

    var version: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? ""
    }
}
