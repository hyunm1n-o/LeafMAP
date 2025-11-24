//
//  PostDetailViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit

class PostDetailViewController: UIViewController {
    // MARK: - Properties
    let postService = PostService()
    let navigationBarManager = NavigationManager()
    let boardCategory: String
    let postId: Int
    
    // 게시글 데이터 & 댓글 데이터
    private var postDetail: PostDetailResponseDTO?
    private var comments: [PostCommentDTO] = []
    
    // MARK: - View
    private lazy var postDetailView = PostDetailView().then {
        $0.recommendButton.addTarget(self, action: #selector(didTapRecommend), for: .touchUpInside)
        $0.editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        $0.deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        $0.sendButton.addTarget(self, action: #selector(didTapSendComment), for: .touchUpInside)
    }
    
    // MARK: - init
    init(boardCategory: String, postId: Int) {
        self.boardCategory = boardCategory
        self.postId = postId
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
        callGetBoardDetail()
        
        // 테이블뷰 높이 observer 추가
        postDetailView.commentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        postDetailView.commentTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // 테이블뷰 높이 자동 조정
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                postDetailView.commentTableView.snp.updateConstraints {
                    $0.height.equalTo(newSize.height)
                }
            }
        }
    }
    
    // MARK: - Network
    func callGetBoardDetail() {
        postService.getPostDetail(
            boardType: boardCategory,
            postId: postId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.postDetail = data
                    self.comments = data.comments
                    self.updateUI(with: data)
                    self.postDetailView.commentTableView.reloadData()
                    
                    // 테이블뷰 높이 업데이트
                    DispatchQueue.main.async {
                        self.postDetailView.commentTableView.layoutIfNeeded()
                    }
                    
                    print("✅ 게시글 상세 로드 성공")
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                }
            })
    }
    
    // 좋아요 토글 API
    func callPostToggleLike() {
        postService.toggleLike(
            boardType: boardCategory,
            postId: postId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    print("✅ 좋아요 토글 성공")
                    print("  - postId: \(data.postId)")
                    print("  - likeCount: \(data.likeCount)")
                    print("  - isLiked: \(data.isLiked)")
                    
                    // UI만 업데이트
                    self.postDetailView.recommendButton.isSelected = data.isLiked
                    self.postDetailView.updateLikeCount(data.likeCount)
                    
                case .failure(let error):
                    print("❌ 좋아요 토글 실패: \(error.localizedDescription)")
                    
                    // 실패 시 원래 상태로 되돌리기
                    if let detail = self.postDetail {
                        self.postDetailView.recommendButton.isSelected = detail.isLiked
                        self.postDetailView.updateLikeCount(detail.likeCount)
                    }
                }
            })
    }
    
    // 게시글 삭제 API
    func callDeletePost() {
        postService.deletePost(
            boardType: boardCategory,
            postId: postId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("✅ 게시글 삭제 성공")
                    
                    // 삭제 성공 시 이전 화면으로 이동
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(let error):
                    print("❌ 게시글 삭제 실패: \(error.localizedDescription)")
                    
                    // 에러 알림
                    let alert = UIAlertController(
                        title: "삭제 실패",
                        message: "게시글을 삭제할 수 없습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            })
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
    
    @objc
    private func didTapRecommend() {
        postDetailView.recommendButton.isSelected.toggle()
        callPostToggleLike()
    }
    
    @objc
    private func didTapEdit() {
        guard let postDetail = postDetail else { return }
        
        let editMode = PostMode.edit(postId: postId, existingData: postDetail)
        let editVC = AddPostViewController(boardCategory: boardCategory, mode: editMode)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    private func didTapDelete() {
        let alert = UIAlertController(
            title: "게시글 삭제",
            message: "정말로 이 게시글을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.callDeletePost()
        })
        
        present(alert, animated: true)
    }
    
    @objc
    private func didTapSendComment() {
        guard let commentText = postDetailView.commentTextField.text,
              !commentText.isEmpty else { return }
        
        // TODO: 댓글 작성 API 호출
        print("댓글 전송: \(commentText)")
        postDetailView.commentTextField.text = ""
        view.endEditing(true)
    }
    
    //MARK: - Setup UI
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        let displayTitle = BoardType(rawValue: boardCategory)?.koreanName ?? boardCategory
        navigationBarManager.setTitle(
            to: navigationItem,
            title: displayTitle,
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    private func updateUI(with data: PostDetailResponseDTO) {
        postDetailView.configure(
            title: data.title,
            content: data.content,
            address: data.address,
            authorInfo: data.authorInfo,
            likeCount: data.likeCount,
            isLiked: data.isLiked,
            isWriter: data.isWriter,
            badge: data.badge,
            imageUrl: data.imageUrl
        )
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
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
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
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        postDetailView.bottomConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Extension
extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else { return UITableViewCell() }

        let comment = comments[indexPath.row]
        
        cell.configure(
            nickname: comment.authorInfo,
            content: comment.content,
            depth: 0,
            isAuthor: comment.isWriter
        )

        cell.detailButton.tag = indexPath.row
        cell.detailButton.addTarget(
            self,
            action: #selector(didTapDetailButton(_:)),
            for: .touchUpInside
        )

        return cell
    }

    @objc
    private func didTapDetailButton(_ sender: UIButton) {
        let row = sender.tag
        let comment = comments[row]

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if comment.isWriter {
            sheet.addAction(UIAlertAction(title: "수정하기", style: .default, handler: { _ in
                print("수정하기 눌림 — commentId: \(comment.commentId)")
            }))
            sheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { _ in
                print("삭제하기 눌림 — commentId: \(comment.commentId)")
            }))
        } else {
            sheet.addAction(UIAlertAction(title: "답글 달기", style: .default, handler: { _ in
                print("답글달기 눌림 — commentId: \(comment.commentId)")
            }))
        }

        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(sheet, animated: true)
    }
}
