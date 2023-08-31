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

    func fetchPosts(filter: PostFilter) -> Observable<APIResult<[Post]?>> {
        return postAPIRepo.fetchPosts(with: filter)
    }

    func posting(form: PostingForm) -> Observable<APIResult<PostingResult>> {
        return postAPIRepo.posting(form: form)
    }

    func bookmark(postId: Int, mark: Bool) -> Observable<APIResult<(postId: Int, mark: Bool)>> {
        return postAPIRepo.bookmark(postId: postId, mark: mark)
    }

    func detailInfo(postId: Int) -> Observable<APIResult<DetailInfoResult>> {
        return postAPIRepo.detailInfo(postId: postId)
    }

    func apply(postId: Int) -> Observable<APIResult<Bool>> {
        return postAPIRepo.apply(postId: postId)
    }

    func accept(postId: Int, applicantId: Int, accept: Bool) -> Observable<APIResult<(id: Int, accept: Bool, success: Bool)>> {
        return postAPIRepo.accept(postId: postId, applicantId: applicantId, accept: accept)
    }

    func close(postId: Int) -> Observable<APIResult<Bool>> {
        return postAPIRepo.close(postId: postId)
    }

    func delete(postId: Int) -> Observable<APIResult<Bool>> {
        return postAPIRepo.delete(postId: postId)
    }

    func report(postId: Int) -> Observable<APIResult<Bool>> {
        return postAPIRepo.report(postId: postId)
    }

    //    func myPage() -> Observable<APIResult<MyPageAPIResult>>
    //    func getRunnerList() -> Observable<APIResult<[MyPosting]?>>
    //    func mangageAttendance(postId: Int, request: PatchAttendanceRequest) -> Observable<APIResult<Bool>>
    //    func attendance(postId: Int) -> Observable<APIResult<(postId: Int, success: Bool)>>
}
