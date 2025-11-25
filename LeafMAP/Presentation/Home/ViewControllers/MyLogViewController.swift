//
//  MyLogViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

enum LogType: Int, CaseIterable {
    case myPosts = 0        // 작성된 게시글 (isPublic = true)
    case pendingPosts = 1   // 전달된 게시글 (isPublic = false)
    case myComments = 2     // 내가 단 댓글
    case likedPosts = 3     // 추천하기 누른 게시글
    
    var iconName: String {
        switch self {
        case .myPosts: return "pen"
        case .pendingPosts: return "post"
        case .myComments: return "comment"
        case .likedPosts: return "leaf"
        }
    }
    
    var title: String {
        switch self {
        case .myPosts: return "작성된 게시글"
        case .pendingPosts: return "전달된 게시글"
        case .myComments: return "내가 단 댓글"
        case .likedPosts: return "추천하기 누른 게시글"
        }
    }
}

class MyLogViewController: UIViewController {
    //MARK: - Properties
    let navigationBarManager = NavigationManager()
    let memberService = MemberService()
    
    private var logCounts: [LogType: Int] = [:]
    
    // MARK: - View
    private lazy var myLogView = MyLogView()

    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myLogView)
        myLogView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setupTableView()
        loadAllCounts()
    }
    
    //MARK: - Setup
    private func setupTableView() {
        myLogView.logTableView.delegate = self
        myLogView.logTableView.dataSource = self
    }
    
    // 모든 카운트 불러오기
    private func loadAllCounts() {
        let group = DispatchGroup()
        
        // 작성된 게시글 수
        group.enter()
        memberService.getMyPosts(cursor: 0, limit: 1) { [weak self] result in
            if case .success(let data) = result {
                let publicPosts = data.posts.filter { $0.isPublic }
                self?.logCounts[.myPosts] = publicPosts.count
            }
            group.leave()
        }
        
        // 전달된 게시글 수
        group.enter()
        memberService.getMyPosts(cursor: 0, limit: 1) { [weak self] result in
            if case .success(let data) = result {
                let pendingPosts = data.posts.filter { !$0.isPublic }
                self?.logCounts[.pendingPosts] = pendingPosts.count
            }
            group.leave()
        }
        
        // 댓글 단 게시글 수
        group.enter()
        memberService.getMyComments(cursor: 0, limit: 1) { [weak self] result in
            if case .success(let data) = result {
                self?.logCounts[.myComments] = data.posts.count
            }
            group.leave()
        }
        
        // 추천한 게시글 수
        group.enter()
        memberService.getLikedPosts(cursor: 0, limit: 1) { [weak self] result in
            if case .success(let data) = result {
                self?.logCounts[.likedPosts] = data.posts.count
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.myLogView.logTableView.reloadData()
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

        navigationBarManager.setTitle(
            to: navigationItem,
            title: "나의 발자취 보기",
            textColor: .gray900
        )

        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension MyLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyLogTableViewCell.identifier,
            for: indexPath
        ) as? MyLogTableViewCell,
              let logType = LogType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        let count = logCounts[logType] ?? 0
        cell.configure(iconName: logType.iconName, title: logType.title, count: count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let logType = LogType(rawValue: indexPath.row) else { return }
        
        // 게시글 목록 화면으로 이동
        let nextVC = MyLogDetailViewController(logType: logType)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
