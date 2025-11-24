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
    private var displayComments: [PostCommentDTO] = []
    private var replyMode: (isActive: Bool, parentCommentId: Int, parentAuthor: String) = (false, 0, "")
    
    // MARK: - View
    private lazy var postDetailView = PostDetailView().then {
        $0.recommendButton.addTarget(self, action: #selector(didTapRecommend), for: .touchUpInside)
        $0.editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        $0.deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        $0.sendButton.addTarget(self, action: #selector(didTapSendComment), for: .touchUpInside)
        $0.cancelReplyButton.addTarget(self, action: #selector(didTapCancelReply), for: .touchUpInside)
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
                    
                    // 댓글을 계층 구조로 정렬
                    self.displayComments = self.sortCommentsHierarchically(self.comments)
                    
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
    
    // 댓글을 계층 구조로 정렬 (부모 댓글 바로 밑에 자식 댓글)
    private func sortCommentsHierarchically(_ comments: [PostCommentDTO]) -> [PostCommentDTO] {
        var result: [PostCommentDTO] = []
        
        // 1. 부모 댓글들 (parentId가 nil인 것들)
        let parentComments = comments.filter { $0.parentId == nil }
        
        // 2. 각 부모 댓글마다 자식 댓글들을 바로 밑에 추가
        for parent in parentComments {
            result.append(parent)
            
            // 이 부모의 자식 댓글들 찾기
            let children = comments.filter { $0.parentId == parent.commentId }
            result.append(contentsOf: children)
        }
        
        return result
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
                    self.postDetailView.recommendButton.isSelected = data.isLiked
                    self.postDetailView.updateLikeCount(data.likeCount)
                    
                case .failure(let error):
                    print("❌ 좋아요 토글 실패: \(error.localizedDescription)")
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
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(let error):
                    print("❌ 게시글 삭제 실패: \(error.localizedDescription)")
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
    
    // 댓글 작성 API
    func callCreateComment(content: String, parentId: Int? = 0) {
        let requestData = PostCommentRequestDTO(
            content: content,
            parentId: parentId
        )
        
        postService.createComment(
            postId: postId,
            data: requestData,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let newComment):
                    print("✅ 댓글 작성 성공: \(newComment.commentId)")
                    
                    // 답글 모드 해제
                    self.exitReplyMode()
                    
                    // 댓글 목록 새로고침
                    self.callGetBoardDetail()
                    
                case .failure(let error):
                    print("❌ 댓글 작성 실패: \(error.localizedDescription)")
                    let alert = UIAlertController(
                        title: "댓글 작성 실패",
                        message: "댓글을 작성할 수 없습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            })
    }
    
    // 댓글 삭제 API
    func callDeleteComment(commentId: Int) {
        postService.deleteComment(
            postId: postId,
            commentId: commentId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("✅ 댓글 삭제 성공")
                    self.callGetBoardDetail()
                    
                case .failure(let error):
                    print("❌ 댓글 삭제 실패: \(error.localizedDescription)")
                    let alert = UIAlertController(
                        title: "삭제 실패",
                        message: "댓글을 삭제할 수 없습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            })
    }
    
    // MARK: - Reply Mode
    // 답글 모드 진입
    private func enterReplyMode(parentCommentId: Int, parentAuthor: String) {
        replyMode = (true, parentCommentId, parentAuthor)
        postDetailView.setReplyMode(isActive: true, parentAuthor: parentAuthor)
        postDetailView.commentTextField.becomeFirstResponder()
    }
    
    // 답글 모드 해제
    private func exitReplyMode() {
        replyMode = (false, 0, "")
        postDetailView.setReplyMode(isActive: false, parentAuthor: "")
        postDetailView.commentTextField.text = ""
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
        guard let commentText = postDetailView.commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !commentText.isEmpty else { return }
        
        // 답글 모드인지 확인
        if replyMode.isActive {
            // 대댓글 작성
            callCreateComment(content: commentText, parentId: replyMode.parentCommentId)
        } else {
            // 일반 댓글 작성
            callCreateComment(content: commentText, parentId: 0)
        }
        
        view.endEditing(true)
    }
    
    // 답글 취소 버튼
    @objc
    private func didTapCancelReply() {
        exitReplyMode()
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
        return displayComments.count  // 정렬된 댓글 사용
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else { return UITableViewCell() }

        let comment = displayComments[indexPath.row]
        
        // depth 계산
        let depth = comment.parentId != nil ? 1 : 0
        
        cell.configure(
            nickname: comment.authorInfo,
            content: comment.content,
            depth: depth,
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
        let comment = displayComments[row]

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if comment.isWriter {
            sheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { [weak self] _ in
                self?.showDeleteCommentAlert(commentId: comment.commentId)
            }))
            sheet.addAction(UIAlertAction(title: "답글 달기", style: .default, handler: { [weak self] _ in
                // 답글 모드 진입
                self?.enterReplyMode(parentCommentId: comment.commentId, parentAuthor: comment.authorInfo)
            }))
        } else {
            sheet.addAction(UIAlertAction(title: "답글 달기", style: .default, handler: { [weak self] _ in
                // 답글 모드 진입
                self?.enterReplyMode(parentCommentId: comment.commentId, parentAuthor: comment.authorInfo)
            }))
        }

        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(sheet, animated: true)
    }
    
    // 댓글 삭제 확인 알림
    private func showDeleteCommentAlert(commentId: Int) {
        let alert = UIAlertController(
            title: "댓글 삭제",
            message: "정말로 이 댓글을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.callDeleteComment(commentId: commentId)
        })
        
        present(alert, animated: true)
    }
}
