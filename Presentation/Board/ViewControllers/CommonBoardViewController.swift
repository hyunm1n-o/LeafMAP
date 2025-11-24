//
//  CommonBoardViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit

class CommonBoardViewController: UIViewController {
    // MARK: - Properties
    let postService = PostService()
    let navigationBarManager = NavigationManager()
    let boardCategory: String
    
    // 페이지네이션 관련 프로퍼티
    private var posts: [PostPreviewDTO] = []
    private var currentCursor: Int = 0
    private var hasNext: Bool = true
    private let limit: Int = 20
    private var isLoading: Bool = false
    
    // MARK: - View
    private lazy var commonBoradView = CommonBoardView().then {
        $0.writeButton.addTarget(self, action: #selector(didTapWriteButton), for: .touchUpInside)
    }
    
    // MARK: - init
    init(boardCategory: String) {
        self.boardCategory = boardCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(commonBoradView)
        
        commonBoradView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setDelegate()
        callGetBoardList()
    }
    
    // MARK: - Network
    func callGetBoardList() {
        guard !isLoading && hasNext else { return }
        
        isLoading = true
        
        postService.getPostList(
            boardType: boardCategory,
            cursor: currentCursor,
            limit: limit,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    self.posts.append(contentsOf: data.posts)
                    self.currentCursor = data.nextCursor
                    self.hasNext = data.hasNext
                    self.commonBoradView.postTableView.reloadData()
                    
                    print("✅ 게시글 \(data.posts.count)개 로드 (전체: \(self.posts.count)개)")
                    
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                }
            })
    }
    
    // MARK: - Functional
    private func setDelegate() {
        commonBoradView.postTableView.delegate = self
        commonBoradView.postTableView.dataSource = self
    }
    
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapWriteButton() {
        let nextVC = AddPostViewController(boardCategory: boardCategory)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - Setup UI
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        let displayTitle = BoardType(rawValue: boardCategory)?.koreanName ?? boardCategory
        navigationBarManager.setTitle(
            to: navigationItem,
            title: displayTitle,
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
}
// MARK: - UITableView Delegate & DataSource
extension CommonBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            postInfo: post.authorInfo,
            isCertified: post.badge
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        print("게시글 \(post.postId) 선택")
        
        let nextVC = PostDetailViewController(boardCategory: boardCategory, postId: post.postId)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // 무한 스크롤 구현
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 마지막 셀에 도달하면 다음 페이지 로드
        if indexPath.row == posts.count - 1 && hasNext {
            callGetBoardList()
        }
    }
}
