//
//  SignupViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class SignupViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    
    // MARK: - View
    private lazy var signupView = SignupView().then {
        $0.nextButton.addTarget(self, action: #selector(goToSelectMajor), for: .touchUpInside)
    }
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signupView)
        
        signupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
    }
    
    //MARK: - Functional
    //MARK: Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func goToSelectMajor() {
        let nextVC = SelectMajorViewController()
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

        navigationBarManager.setTitle(
            to: navigationItem,
            title: "회원가입",
            textColor: .gray900
        )

        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
}

