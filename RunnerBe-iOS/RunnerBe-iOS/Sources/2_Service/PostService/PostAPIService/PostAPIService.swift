//
//  PostAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import RxSwift

enum PostingResult {
    case succeed, fail, needLogin
}

enum DetailInfoResult {
    case writer(post: Post, marked: Bool, participants: [User], applicant: [User])
    case guest(post: Post, marked: Bool, apply: Bool, participants: [User])
    case error
}

enum MyPageAPIResult {
    case success(info: User, posting: [Post], joined: [Post])
    case error
}

protocol PostAPIService {
    func fetchPosts(with filter: PostFilter) -> Observable<[Post]?>
    func fetchPostsBookMarked() -> Observable<[Post]?>
    func posting(form: PostingForm) -> Observable<PostingResult>
    func bookmark(postId: Int, mark: Bool) -> Observable<(postId: Int, mark: Bool)>
    func detailInfo(postId: Int) -> Observable<DetailInfoResult>
    func apply(postId: Int) -> Observable<Bool>
    func accept(postId: Int, applicantId: Int, accept: Bool) -> Observable<(id: Int, success: Bool)>
    func close(postId: Int) -> Observable<Bool>
    func myPage() -> Observable<MyPageAPIResult>
}
