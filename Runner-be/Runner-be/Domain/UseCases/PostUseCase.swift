//
//  PostUseCase.swift
//  Runner-be
//
//  Created by 이유리 on 2023/08/23.
//

import Foundation
import RxSwift

final class PostUseCase {
    private var postAPIRepo: PostAPIService = BasicPostAPIService()

    // MARK: - Network

    func fetchPostBookMarked() -> Observable<APIResult<[Post]?>> {
        return postAPIRepo.fetchPostsBookMarked()
    }
}
