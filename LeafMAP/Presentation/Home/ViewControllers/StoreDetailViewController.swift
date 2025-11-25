//
//  StoreDetailViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit

class StoreDetailViewController: UIViewController {
    // MARK: - Properties
    let postService = PostService()
    let navigationBarManager = NavigationManager()
    let postId: Int
    
    private var postDetail: PostDetailResponseDTO?
    
    // MARK: - View
    private lazy var storeDetailView = StoreDetailView().then {
        $0.recommendButton.addTarget(self, action: #selector(didTapRecommend), for: .touchUpInside)
    }
    
    // MARK: - init
    init(postId: Int) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(storeDetailView)
        
        storeDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        callGetBoardDetail()
    }
    
    //MARK: - Network
    func callGetBoardDetail() {
        postService.getPostDetail(
            boardType: "RESTAURANT",
            postId: postId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.postDetail = data
                    self.updateUI(with: data)
                    print("✅ 맛집 상세 로드 성공")
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                }
            })
    }
    
    // 좋아요 토글 API
    func callPostToggleLike() {
        postService.toggleLike(
            boardType: "RESTAURANT",
            postId: postId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    print("✅ 좋아요 토글 성공")
                    print("  - postId: \(data.postId)")
                    print("  - likeCount: \(data.likeCount)")
                    print("  - isLiked: \(data.isLiked)")
                    
                    // UI만 업데이트
                    self.storeDetailView.recommendButton.isSelected = data.isLiked
                    self.storeDetailView.updateLikeCount(data.likeCount)
                    
                case .failure(let error):
                    print("❌ 좋아요 토글 실패: \(error.localizedDescription)")
                    
                    // 실패 시 원래 상태로 되돌리기
                    if let detail = self.postDetail {
                        self.storeDetailView.recommendButton.isSelected = detail.isLiked
                        self.storeDetailView.updateLikeCount(detail.likeCount)
                    }
                }
            })
    }
    
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapRecommend() {
        // TODO: 좋아요 API 호출
        storeDetailView.recommendButton.isSelected.toggle()
        callPostToggleLike()
    }
    
    //MARK: - Setup UI
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "로딩 중...",  // 임시 타이틀
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    private func updateUI(with data: PostDetailResponseDTO) {
        // 네비게이션 타이틀 업데이트
        navigationBarManager.setTitle(
            to: navigationItem,
            title: data.title,
            textColor: .gray900
        )
        
        // 뷰 업데이트
        storeDetailView.configure(
            title: data.title,
            address: data.address,
            imageUrl: data.imageUrl,
            likeCount: data.likeCount,
            isLiked: data.isLiked
        )
    }
    
}
