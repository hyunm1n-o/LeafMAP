//
//  TestViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class TestViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    let justOneService = JustOneService()
    
    private var questions: [JustOneQuestionDTO] = []
    private var answers: [Int: Int] = [:]  // [questionId: score]
    
    // MARK: - View
    private let testView = TestView()
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testView)
        
        testView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setupActions()
        callGetQuestions()
    }
    
    // MARK: - Network
    func callGetQuestions() {
        justOneService.getQuestions(
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    print("✅ 질문 로드 성공: \(data.questions.count)개")
                    self.questions = data.questions
                    self.setupQuestionViews()
                    
                case .failure(let error):
                    print("❌ 질문 로드 실패: \(error.localizedDescription)")
                    self.showErrorAlert()
                }
            })
    }
    
    // MARK: - Setup
    private func setupQuestionViews() {
        // 기존 뷰 제거
        testView.questionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 질문 뷰 생성
        for (index, question) in questions.enumerated() {
            let questionView = TestBoxView()
            questionView.configure(question: "\(index + 1). \(question.content)")
            
            // 점수 선택 콜백
            questionView.onScoreSelected = { [weak self] score in
                self?.answers[question.questionId] = score
                self?.updateSubmitButton()
            }
            
            testView.questionsStackView.addArrangedSubview(questionView)
        }
    }
    
    private func setupActions() {
        testView.submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    private func updateSubmitButton() {
        // 모든 질문에 답했는지 확인
        let allAnswered = answers.count == questions.count
        
        testView.submitButton.isEnabled = allAnswered
        testView.submitButton.backgroundColor = allAnswered ? UIColor.green01 : UIColor.gray1
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
    
    @objc
    private func didTapSubmit() {
        guard answers.count == questions.count else {
            let alert = UIAlertController(
                title: "알림",
                message: "모든 질문에 답해주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
    
        let answerArray = answers.map { JustOneAnswerDTO(questionId: $0.key, score: $0.value) }
        let loadingVC = TestLoadingViewController(answers: answerArray)
        navigationController?.pushViewController(loadingVC, animated: true)
    }
    
    // MARK: - Alert
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "오류",
            message: "문제가 발생했습니다. 다시 시도해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
