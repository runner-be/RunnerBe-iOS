//
//  MainPageAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import RxSwift

enum PostingResult {
    case succeed, fail, needLogin
}

protocol MainPageAPIService {
    func fetchPosts(with filter: PostFilter) -> Observable<[Post]?>
    func posting(form: PostingForm) -> Observable<PostingResult>
    func bookmark(postId: Int, mark: Bool) -> Observable<(postId: Int, mark: Bool)>
}
