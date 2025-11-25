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
    let memberService = MemberService()
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
        $0.hopeMajorButton.addTarget(self, action: #selector(didTapHopeMajorButton), for: .touchUpInside)
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
        
        // 내희망학과 바로가기 버튼 (학과 팁 게시판이 아닐 때만 표시)
        commonBoradView.setMajorList(boardCategory != "MAJOR_TIPS")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 게시글 작성/수정 후 돌아왔을 때 목록 새로고침
        if posts.count > 0 {
            posts.removeAll()
            currentCursor = 0
            hasNext = true
            callGetBoardList()
        }
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

    @objc
    private func didTapHopeMajorButton() {
        print("내 희망학과 바로가기 클릭")

        // 사용자 정보에서 희망학과 가져오기
        memberService.getMember { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let memberData):
                let desiredMajor = memberData.desiredMajor
                print("희망학과: \(desiredMajor)")

                // 학과 팁 게시글 목록에서 해당 학과 찾기
                self.postService.getPostList(
                    boardType: "MAJOR_TIPS",
                    cursor: 0,
                    limit: 100,
                    completion: { [weak self] result in
                        guard let self = self else { return }

                        switch result {
                        case .success(let data):
                            print("📋 전체 게시글 수: \(data.posts.count)")
                            data.posts.forEach { post in
                                print("  - majorName: '\(post.majorName)', postId: \(post.postId)")
                            }

                            // 희망학과와 일치하는 게시글 찾기 (정확히 일치 또는 포함)
                            let matchingPost = data.posts.first { post in
                                post.majorName == desiredMajor ||
                                post.majorName.contains(desiredMajor) ||
                                desiredMajor.contains(post.majorName)
                            }

                            if let matchingPost = matchingPost {
                                print("✅ 희망학과 게시글 찾음: postId=\(matchingPost.postId), majorName=\(matchingPost.majorName)")

                                let nextVC = MajorTipViewController(
                                    postId: matchingPost.postId,
                                    shouldScrollToComments: false,
                                    majorName: matchingPost.majorName
                                )
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            } else {
                                // 일치하는 게시글이 없을 경우 알림
                                print("❌ 희망학과 '\(desiredMajor)'와 일치하는 게시글 없음")
                                let alert = UIAlertController(
                                    title: "알림",
                                    message: "희망학과(\(desiredMajor))에 대한 게시글을 찾을 수 없습니다.",
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "확인", style: .default))
                                self.present(alert, animated: true)
                            }

                        case .failure(let error):
                            print("❌ 학과 팁 목록 로드 실패: \(error.localizedDescription)")
                        }
                    })

            case .failure(let error):
                print("❌ 회원 정보 로드 실패: \(error.localizedDescription)")
            }
        }
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
        
        //  학과 게시판이면 MajorTipViewController로 이동
        if boardCategory == "MAJOR_TIPS" {
            let nextVC = MajorTipViewController(
                postId: post.postId,
                shouldScrollToComments: false,
                majorName: post.majorName
            )
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            // 일반 게시판은 PostDetailViewController로 이동
            let nextVC = PostDetailViewController(boardCategory: boardCategory, postId: post.postId)
            navigationController?.pushViewController(nextVC, animated: true)
        }
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
