//
//  MyLogDetailViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class MyLogDetailViewController: UIViewController {
    // MARK: - Properties
    let memberService = MemberService()
    let navigationBarManager = NavigationManager()
    let logType: LogType
    
    // 페이지네이션
    private var posts: [MemberPostDTO] = []
    private var currentCursor: Int = 0
    private var hasNext: Bool = true
    private let limit: Int = 20
    private var isLoading: Bool = false
    
    // MARK: - View
    private lazy var commonBoardView = CommonBoardView().then {
        $0.writeButton.isHidden = true  // 작성 버튼 숨김
        $0.hopeMajorButton.isHidden = true
    }
    
    // MARK: - init
    init(logType: LogType) {
        self.logType = logType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(commonBoardView)
        
        commonBoardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setDelegate()
        callGetPosts()
    }
    
    // MARK: - Network
    func callGetPosts() {
        guard !isLoading && hasNext else { return }
        
        isLoading = true
        
        let completion: (Result<MemberGetMyPostsDTO, NetworkError>) -> Void = { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let data):
                // isPublic 필터링
                let filteredPosts: [MemberPostDTO]
                switch self.logType {
                case .myPosts:
                    filteredPosts = data.posts.filter { $0.isPublic }
                case .pendingPosts:
                    filteredPosts = data.posts.filter { !$0.isPublic }
                case .myComments, .likedPosts:
                    filteredPosts = data.posts
                }
                
                self.posts.append(contentsOf: filteredPosts)
                self.currentCursor = data.nextCursor
                self.hasNext = data.hasNext
                self.commonBoardView.postTableView.reloadData()
                
                print("✅ 게시글 \(filteredPosts.count)개 로드")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
        
        switch logType {
        case .myPosts, .pendingPosts:
            memberService.getMyPosts(cursor: currentCursor, limit: limit, completion: completion)
        case .myComments:
            memberService.getMyComments(cursor: currentCursor, limit: limit, completion: completion)
        case .likedPosts:
            memberService.getLikedPosts(cursor: currentCursor, limit: limit, completion: completion)
        }
    }
    
    // MARK: - Setup
    private func setDelegate() {
        commonBoardView.postTableView.delegate = self
        commonBoardView.postTableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: logType.title,
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension MyLogDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.identifier,
            for: indexPath
        ) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.configure(
            title: post.title,
            content: post.contentPreview,
            postInfo: post.createdAt,
            isCertified: post.badge
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        
        print("🔗 게시글 선택: postId=\(post.postId), boardType=\(post.boardType)")
        
        // boardType이 비어있는 경우
        if post.boardType.isEmpty {
            let alert = UIAlertController(
                title: "알림",
                message: "게시글 정보를 불러올 수 없습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        // 게시글 상세로 이동
        if post.boardType == "MAJOR_TIPS" {
            let nextVC = MajorTipViewController(postId: post.postId)
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = PostDetailViewController(boardCategory: post.boardType, postId: post.postId)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == posts.count - 1 && hasNext {
            callGetPosts()
        }
    }
}
