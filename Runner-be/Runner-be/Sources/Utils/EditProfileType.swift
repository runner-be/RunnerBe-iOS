//
//  EditProfileType.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/19.
//

import Photos
import UIKit

enum EditProfileType {
    case library
    case camera
}

extension EditProfileType {
    var sourceType: String {
        switch self {
        case .camera:
            return "camera"
        case .library:
            return "library"
        }
    }
}
