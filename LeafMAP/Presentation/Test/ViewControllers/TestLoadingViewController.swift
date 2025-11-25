//
//  TestLoadingViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class TestLoadingViewController: UIViewController {
    
    // MARK: - Properties
    let justOneService = JustOneService()
    let answers: [JustOneAnswerDTO]
    let navigationBarManager = NavigationManager()
    
    // MARK: - View
    private let loadingView = TestLoadingView()
    
    // MARK: - init
    init(answers: [JustOneAnswerDTO]) {
        self.answers = answers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
        loadingView.showLoadingIndicator()
        callSubmitAnswers()
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
    
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Network
    func callSubmitAnswers() {
        let requestData = JustOneAptitudeRequestDTO(answers: answers)
        
        justOneService.submitAnswer(
            data: requestData,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    print("✅ 검사 결과 성공")
                    print("  - majorScores: \(data.majorScores)")
                    
                    let topMajor = data.majorScores.max { $0.value < $1.value }
                    let majorName = topMajor?.key ?? "소프트웨어학과"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.loadingView.hideLoadingIndicator()
                        let completeVC = TestCompleteViewController(majorName: majorName)
                        self.navigationController?.pushViewController(completeVC, animated: true)
                    }
                    
                case .failure(let error):
                    print("❌ 검사 결과 실패: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        self.loadingView.hideLoadingIndicator()
                        self.showErrorAlert()
                    }
                }
            })
    }
    
    // MARK: - Alert
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "오류",
            message: "문제가 발생했습니다. 다시 시도해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
