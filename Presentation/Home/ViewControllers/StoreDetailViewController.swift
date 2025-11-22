//
//  StoreDetailViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit

class StoreDetailViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    let storeName: String = "경성마라탕"
    // MARK: - View
    private lazy var storeDetailView = StoreDetailView().then {
        $0.recommendButton.addTarget(self, action: #selector(didTapRecommend), for: .touchUpInside)
    }
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(storeDetailView)
        
        storeDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
    }
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapRecommend() {
        storeDetailView.recommendButton.isSelected.toggle()
        
        if storeDetailView.recommendButton.isSelected {
            print("추천 ON")
        } else {
            print("추천 OFF")
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
            title: storeName,
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
}
