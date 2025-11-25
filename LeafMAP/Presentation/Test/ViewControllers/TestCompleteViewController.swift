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
    
    private let majorMapping: [String: Int] = [
        "경영학부": 11,
        "공공인재학부": 10,
        "글로벌비즈니스어학부": 9,
        "아동청소년학과": 8,
        "토목건축공학과": 7,
        "도시공학과": 6,
        "물류시스템공학과": 5,
        "나노화학생명공학과": 4,
        "전자컴퓨터공학과": 3,
        "금융정보공학과": 2,
        "소프트웨어학과": 1
    ]

    
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
           guard let majorId = majorMapping[majorName] else {
               print("매핑된 majorId 없음")
               return
           }
           
           let nextVC = MajorTipViewController(postId: majorId)
           navigationController?.pushViewController(nextVC, animated: true)
       }
    
    //MARK: - Event
    @objc private func prevVC() {
        navigationController?.popToRootViewController(animated: true)
    }
}
