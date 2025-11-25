//
//  TestCompleteViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class TestCompleteViewController: UIViewController {
    
    // MARK: - Properties
    let majorName: String
    let navigationBarManager = NavigationManager()
    
    // MARK: - View
    private lazy var completeView = TestCompleteView(majorName: majorName).then {
        $0.moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    // MARK: - init
    init(majorName: String) {
        self.majorName = majorName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(completeView)
        completeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupNavigationBar()
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
            title: "나의 성향 알아보기",
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    // MARK: - Event
    @objc
    private func didTapMoreButton() {
        // 학과 팁 게시판으로 이동
        let nextVC = MajorTipViewController(postId: 1)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - Event
    @objc private func prevVC() {
        navigationController?.popToRootViewController(animated: true)
    }
}
