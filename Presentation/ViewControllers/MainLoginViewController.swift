//
//  ViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/19/25.
//

import UIKit

class MainLoginViewController: UIViewController {
    // MARK: - Properties

    // MARK: - View
    private lazy var mainLoginView = MainLoginView().then {
        $0.signupButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
    }
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainLoginView)
        
        mainLoginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Functional
    //MARK: Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func goToSignUp() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    //MARK: - Setup UI
}
