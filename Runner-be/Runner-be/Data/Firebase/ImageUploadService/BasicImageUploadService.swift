//
//  BasicImageUploadService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import FirebaseStorage
import Foundation
import RxSwift

final class BasicImageUploadService: ImageUploadService {
    let storage: Storage

    init(storage: Storage = .storage()) {
        self.storage = storage
    }

    func uploadImage(data: Data, path: String) -> Observable<String?> {
        let storageRef = storage.reference().child(path)

        let metaData = StorageMetadata()
        metaData.contentType = "image/png"

        return Observable<String?>.create { observer in
            storageRef.putData(data, metadata: metaData) { _, error in
                if let error = error {
                    Log.e("error: \(error)")
                    observer.onNext(nil)
                    return
                }

                storageRef.downloadURL { url, error in
                    if let url = url {
                        observer.onNext(url.absoluteString)
                    } else {
                        if let error = error {
                            Log.e("error: \(error)")
                        }
                        observer.onNext(nil)
                    }
                }
            }

            return Disposables.create()
        }
    }
}
