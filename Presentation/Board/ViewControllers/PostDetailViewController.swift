//
//  PostDetailViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit

struct Comment {
    let nickname: String
    let content: String
    let depth: Int   // 0 = 댓글, 1 = 대댓글, 2 = 대대댓글...
    let isAuthor: Bool
}

class PostDetailViewController: UIViewController {
    private var comments: [Comment] = [
        Comment(nickname: "철수 | 2024.10.05", content: "첫 댓글입니다", depth: 0, isAuthor: true),
        Comment(nickname: "민수 | 2024.10.05", content: "첫 댓글에 대한 대댓글", depth: 1, isAuthor: false),
        Comment(nickname: "영희 | 2024.10.05", content: "첫 댓글의 또 다른 대댓글", depth: 1, isAuthor: false),
        Comment(nickname: "보라 | 2024.10.05", content: "두번째 댓글입니다", depth: 0, isAuthor: false),
        Comment(nickname: "준호 | 2024.10.05", content: "두번째 댓글의 대댓글", depth: 1, isAuthor: false),
        Comment(nickname: "나래 | 2024.10.05", content: "세번째 댓글입니다", depth: 0, isAuthor: false)
    ]

    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    let storeCategory: String 
    
    // MARK: - View
    private lazy var postDetailView = PostDetailView()
    
    // MARK: - init
    init(storeCategory: String) {
        self.storeCategory = storeCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(postDetailView)
        
        postDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addKeyboardObservers()
        setupNavigationBar()
        setDelegate()
        addTapGestureToDismissKeyboard()
        
        // 테스트: 뱃지 숨기기 / 주소 숨기기
        postDetailView.setBadgeHidden(true)
        postDetailView.setLocationHidden(true)
        postDetailView.setEditHidden(false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Functional
    private func setDelegate() {
        postDetailView.commentTableView.delegate = self
        postDetailView.commentTableView.dataSource = self
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
    
    // MARK: - Keyboard Setting
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let keyboardHeight = frame.height - view.safeAreaInsets.bottom
        postDetailView.bottomConstraint?.update(offset: -keyboardHeight)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        postDetailView.bottomConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 테이블뷰 셀 터치 막지 않음
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Extension
extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else { return UITableViewCell() }

        let comment = comments[indexPath.row]
        cell.configure(comment)

        // 버튼 클릭 테스트용
        cell.detailButton.tag = indexPath.row
        cell.detailButton.addTarget(self,
                                    action: #selector(didTapDetailButton(_:)),
                                    for: .touchUpInside)

        return cell
    }

    @objc
    private func didTapDetailButton(_ sender: UIButton) {
        let row = sender.tag
        let comment = comments[row]

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if comment.isAuthor {
            // 글쓴이 -> 수정 / 삭제
            sheet.addAction(UIAlertAction(title: "수정하기", style: .default, handler: { _ in
                print("수정하기 눌림 — row: \(row)")
            }))
            sheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { _ in
                print("삭제하기 눌림 — row: \(row)")
            }))
        } else {
            // 글쓴이 아님 -> 답글 달기
            sheet.addAction(UIAlertAction(title: "답글 달기", style: .default, handler: { _ in
                print("답글달기 눌림 — row: \(row)")
                // 여기에 reply mode 활성화 로직 넣으면 됨
            }))
        }

        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(sheet, animated: true)
    }

}
