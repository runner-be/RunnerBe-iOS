//
//  ImagePickerType+.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/19.
//

import Photos
import UIKit

enum ImagePickerType {
    case library
    case camera
}

extension ImagePickerType {
    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .library:
            return .photoLibrary
        }
    }
}
