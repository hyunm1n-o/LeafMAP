//
//  CommonBoardViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit

class CommonBoardViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    let storeCategory: String = "맛집 게시판"

    // MARK: - View
    private lazy var commonBoradView = CommonBoardView()
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(commonBoradView)
        
        commonBoradView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setDelegate()
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
            title: storeCategory,
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
}
// MARK: - UITableView Delegate & DataSource
extension CommonBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 섹션당 행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // 나중에 실제 데이터 배열 개수로 변경
    }
    
    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.identifier,
            for: indexPath
        ) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        // 예시 데이터
        let title = "게시글 제목 \(indexPath.row + 1)"
        let content = "게시글 내용 미리보기 \(indexPath.row + 1)"
        let postInfo = "작성자 | 시간"
        let isCertified = true
        
        cell.configure(title: title, content: content, postInfo: postInfo, isCertified: isCertified)
        
        return cell
    }
    
    // 셀 선택 시 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("게시글 \(indexPath.row + 1) 선택")
    }
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110 // 필요에 따라 동적 높이 적용 가능
    }
}
