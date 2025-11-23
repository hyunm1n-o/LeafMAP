//
//  PostEndpoints.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation
import Moya

enum PostEndpoints {
    // Get
    case getPostList(boardType: String, cursor: Int, limit: Int)
    case getPostDetail(boardType: String, postId: Int)
    case getREShome
    
    // Post
    case postBoardPosts(boardType: String, data: PostCreateRequestDTO, image: Data?)
    case postBoardPostsLike(boardType: String, postId: Int)
    case postComment(postId: Int, data: PostCommentRequestDTO)
    
    // Patch
    case patchBoardPosts(boardType: String, postId: Int, data: PostUpdateRequestDTO, image: Data?)
    
    // Delete
    case deleteBoardPosts(boardType: String, postId: Int)
}

extension PostEndpoints: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.boardURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getPostList(let boardType, _, _):
            return "/\(boardType)/posts"
        case .getPostDetail(let boardType, let postId):
            return "/\(boardType)/posts/\(postId)"
        case .getREShome:
            return "/RESTAURANT/home"
        case .postBoardPosts(let boardType, _, _):
            return "/\(boardType)/posts"
        case .postBoardPostsLike(let boardType, let postId):
            return "/\(boardType)/posts/\(postId)/like"
        case .postComment(let postId, _):
            return "/posts/\(postId)/comments"
        case .patchBoardPosts(let boardType, let postId, _, _):
            return "/\(boardType)/posts/\(postId)"
        case .deleteBoardPosts(let boardType, let postId):
            return "/\(boardType)/posts/\(postId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPostList, .getPostDetail, .getREShome:
            return .get
        case .postBoardPosts, .postBoardPostsLike, .postComment:
            return .post
        case .patchBoardPosts:
            return .patch
        case .deleteBoardPosts:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPostList(_, let cursor, let limit):
            return .requestParameters(
                parameters: [
                    "cursor": cursor,
                    "limit": limit
                ],
                encoding: URLEncoding.queryString
            )
            
        case .getPostDetail, .getREShome:
            return .requestPlain
            
        case .postBoardPosts(_, let data, let image):
            var formData: [MultipartFormData] = []
            
            // JSON 데이터 추가
            if let jsonData = try? JSONEncoder().encode(data) {
                formData.append(MultipartFormData(
                    provider: .data(jsonData),
                    name: "data",
                    mimeType: "application/json"
                ))
            }
            
            // 이미지 데이터 추가 (optional)
            if let imageData = image {
                formData.append(MultipartFormData(
                    provider: .data(imageData),
                    name: "image",
                    fileName: "image.jpg",
                    mimeType: "image/jpeg"
                ))
            }
            
            return .uploadMultipart(formData)
            
        case .postBoardPostsLike:
            return .requestPlain
            
        case .postComment(_, let data):
            return .requestJSONEncodable(data)
            
        case .patchBoardPosts(_, _, let data, let image):
            var formData: [MultipartFormData] = []
            
            // JSON 데이터 추가
            if let jsonData = try? JSONEncoder().encode(data) {
                formData.append(MultipartFormData(
                    provider: .data(jsonData),
                    name: "data",
                    mimeType: "application/json"
                ))
            }
            
            // 이미지 데이터 추가 (optional)
            if let imageData = image {
                formData.append(MultipartFormData(
                    provider: .data(imageData),
                    name: "image",
                    fileName: "image.jpg",
                    mimeType: "image/jpeg"
                ))
            }
            
            return .uploadMultipart(formData)
            
        case .deleteBoardPosts:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postBoardPosts, .patchBoardPosts:
            return [
                "accept": "*/*"
                // Content-Type은 Moya가 multipart/form-data로 자동 설정
            ]
        default:
            return [
                "Content-type": "application/json",
                "accept": "*/*"
            ]
        }
    }
}

