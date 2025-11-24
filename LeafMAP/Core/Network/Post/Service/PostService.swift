//
//  PostService.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation
import Moya

final class PostService: NetworkManager {
    
    let provider: MoyaProvider<PostEndpoints>
    
    init(provider: MoyaProvider<PostEndpoints>? = nil) {
        let plugins: [PluginType] = [
            // NetworkLoggerPlugin(configuration: .init(logOptions: [.requestHeaders, .verbose]))
            AuthPlugin.shared
        ]
        
        self.provider = provider ?? MoyaProvider<PostEndpoints>(plugins: plugins)
    }
    
    // 게시판 목록 조회
    func getPostList(boardType: String, cursor: Int, limit: Int, completion: @escaping (Result<PostListResponseDTO, NetworkError>) -> Void) {
        request(
            target: .getPostList(boardType: boardType, cursor: cursor, limit: limit),
            decodingType: PostListResponseDTO.self,
            completion: completion
        )
    }
    
    // 게시글 상세 조회
    func getPostDetail(boardType: String, postId: Int, completion: @escaping (Result<PostDetailResponseDTO, NetworkError>) -> Void) {
        request(
            target: .getPostDetail(boardType: boardType, postId: postId),
            decodingType: PostDetailResponseDTO.self,
            completion: completion
        )
    }
    
    // 맛집 게시판 홈 화면 조회
    func getRestaurantHome(completion: @escaping (Result<RestaurantPostListResponseDTO, NetworkError>) -> Void) {
        request(
            target: .getREShome,
            decodingType: RestaurantPostListResponseDTO.self,
            completion: completion
        )
    }
    
    // 게시글 작성
    func createPost(boardType: String, data: PostCreateRequestDTO, image: Data?, completion: @escaping (Result<PostCreateResponseDTO, NetworkError>) -> Void) {
        request(
            target: .postBoardPosts(boardType: boardType, data: data, image: image),
            decodingType: PostCreateResponseDTO.self,
            completion: completion
        )
    }
    
    // 게시글 수정
    func updatePost(boardType: String, postId: Int, data: PostUpdateRequestDTO, image: Data?, completion: @escaping (Result<PostCreateResponseDTO, NetworkError>) -> Void) {
        request(
            target: .patchBoardPosts(boardType: boardType, postId: postId, data: data, image: image),
            decodingType: PostCreateResponseDTO.self,
            completion: completion
        )
    }
    
    // 게시글 삭제
    func deletePost(boardType: String, postId: Int, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestStatusCode(
            target: .deleteBoardPosts(boardType: boardType, postId: postId),
            completion: completion
        )
    }
    
    // 게시글 추천 토글
    func toggleLike(boardType: String, postId: Int, completion: @escaping (Result<PostLikeResponseDTO, NetworkError>) -> Void) {
        request(
            target: .postBoardPostsLike(boardType: boardType, postId: postId),
            decodingType: PostLikeResponseDTO.self,
            completion: completion
        )
    }
    
    // 댓글 작성
    func createComment(postId: Int, data: PostCommentRequestDTO, completion: @escaping (Result<PostCommentResponseDTO, NetworkError>) -> Void) {
        request(
            target: .postComment(postId: postId, data: data),
            decodingType: PostCommentResponseDTO.self,
            completion: completion
        )
    }
    
    // 게시글 삭제
    func deleteComment(postId: Int, commentId:Int, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestStatusCode(
            target: .deleteComment(postId: postId, commentId: commentId),
            completion: completion
        )
    }
}
