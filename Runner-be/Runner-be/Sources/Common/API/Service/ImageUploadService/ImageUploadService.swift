//
//  ImageUploadService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

protocol ImageUploadService {
    func uploadImage(data: Data, path: String) -> Observable<String?>
}
