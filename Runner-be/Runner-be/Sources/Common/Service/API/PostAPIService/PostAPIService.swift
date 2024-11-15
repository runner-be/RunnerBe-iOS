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
    case genderDenied(message: String)
}

enum DetailInfoResult {
    case writer(post: PostDetail, marked: Bool, participants: [User], applicant: [User], roomID: Int?)
    case guest(post: PostDetail, participated: Bool, marked: Bool, apply: Bool, participants: [User], roomID: Int?)
}

enum MyPageAPIResult {
    case success(info: User, posting: [Post], joined: [Post])
}

protocol PostAPIService {
    func fetchPosts(with filter: PostFilter) -> Observable<APIResult<[Post]?>>
    func fetchPostsBookMarked() -> Observable<APIResult<[Post]?>>
    func posting(form: PostingForm) -> Observable<APIResult<PostingResult>>
    func bookmark(postId: Int, mark: Bool) -> Observable<APIResult<(postId: Int, mark: Bool)>>
    func detailInfo(postId: Int) -> Observable<APIResult<DetailInfoResult>>
    func apply(postId: Int) -> Observable<APIResult<Bool>>
    func accept(postId: Int, applicantId: Int, accept: Bool) -> Observable<APIResult<(id: Int, accept: Bool, success: Bool)>>
    func close(postId: Int) -> Observable<APIResult<Bool>>
    func myPage() -> Observable<APIResult<MyPageAPIResult>>
    func getRunnerList() -> Observable<APIResult<[MyPosting]?>>
    func mangageAttendance(postId: Int, request: PatchAttendanceRequest) -> Observable<APIResult<Bool>>
    func delete(postId: Int) -> Observable<APIResult<Bool>>
    func attendance(postId: Int) -> Observable<APIResult<(postId: Int, success: Bool)>>
    func report(postId: Int) -> Observable<APIResult<Bool>>
    func attendanceList(postId: Int) -> Observable<APIResult<[RunnerInfo]>>
}
