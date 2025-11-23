//
//  PostDetailView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit
import SnapKit

class PostDetailView: UIView {
    //MARK: - Properties
    private var address: String = "성북구"
    public var bottomConstraint: Constraint?

    //MARK: - Components
    private lazy var titleLabel = AppLabel(text: "게시글 제목",
                                           font: UIFont(name: AppFontName.pSemiBold, size: 22)!,
                                           textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    private lazy var certificationBadge = UIImageView().then {
        $0.image = UIImage(named: "badge")
    }
    
    public lazy var editButton = SmallTextButton(title: "수정하기")
    
    private lazy var contentLabel = AppLabel(text: "게시글 내용",
                                             font: UIFont(name: AppFontName.pRegular, size: 14)!,
                                           textColor: .gray900).then {
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var locationLabel = AppLabel(text: "📍주소: \(address)",
                                             font: UIFont(name: AppFontName.pRegular, size: 14)!,
                                           textColor: .gray900).then {
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    public lazy var recommendButton = UIButton().then {
        $0.setImage(UIImage(named: "heart_empty"), for: .normal)
        $0.setImage(UIImage(named: "heart_full"), for: .selected)
    }
    
    private lazy var recommendLabel = AppLabel(text: "추천하기",
                                               font: UIFont(name: AppFontName.pRegular, size: 16)!,
                                               textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    private lazy var postInfoLabel = AppLabel(text: "사용자 | 시간",
                                              font: UIFont(name: AppFontName.pRegular, size: 14)!,
                                         textColor: .gray).then {
        $0.textAlignment = .right
    }
    
    private lazy var seperateLine = UIView().then {
        $0.backgroundColor = .disable
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
    
    public lazy var commentTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = true
        $0.isScrollEnabled = true
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    // MARK: - Comment Input Components
    private lazy var bottomContainerView = UIView().then {
        $0.backgroundColor = .white
    }

    private lazy var textFieldContainer = UIView().then {
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 8
    }

    public lazy var commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요"
        $0.font = UIFont(name: AppFontName.pRegular, size: 14)
        $0.textColor = .gray900
        $0.borderStyle = .none
    }

    public lazy var sendButton = UIButton().then {
        $0.setImage(UIImage(named: "send_icon"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Hidden Components
    public func setBadgeHidden(_ isHidden: Bool) {
        certificationBadge.isHidden = isHidden
    }

    public func setLocationHidden(_ isHidden: Bool) {
        locationLabel.isHidden = isHidden
    }
    
    public func setEditHidden(_ isHidden: Bool) {
        editButton.isHidden = isHidden
    }
    
    //MARK: - SetUI
    public func configure(
        title: String,
        content: String,
        address: String?,
        authorInfo: String,
        likeCount: Int,
        isLiked: Bool,
        isWriter: Bool,
        badge: Bool,
        imageUrl: String?
    ) {
        titleLabel.text = title
        contentLabel.text = content
        postInfoLabel.text = authorInfo
        recommendButton.isSelected = isLiked
        recommendLabel.text = "추천하기 (\(likeCount))"
        
        // 뱃지 표시/숨김
        setBadgeHidden(!badge)
        
        // 작성자인 경우 수정 버튼 표시
        setEditHidden(!isWriter)
        
        // 주소가 있는 경우 표시
        if let address = address, !address.isEmpty {
            locationLabel.text = "📍주소: \(address)"
            setLocationHidden(false)
        } else {
            setLocationHidden(true)
        }
        
        // TODO: 이미지가 있으면 표시
        // if let imageUrl = imageUrl { ... }
    }
    
    private func setView() {
        addSubviews([
            titleLabel,
            certificationBadge,
            editButton,
            contentLabel,
            locationLabel,
            recommendButton,
            recommendLabel,
            postInfoLabel,
            seperateLine,
            commentTableView,
            bottomContainerView
        ])
        
        bottomContainerView.addSubview(textFieldContainer)
        textFieldContainer.addSubviews([commentTextField, sendButton])
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        certificationBadge.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.size.equalTo(18)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        recommendButton.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        recommendLabel.snp.makeConstraints {
            $0.centerY.equalTo(recommendButton)
            $0.leading.equalTo(recommendButton.snp.trailing).offset(4)
        }
        
        postInfoLabel.snp.makeConstraints {
            $0.centerY.equalTo(recommendButton)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        seperateLine.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(recommendButton.snp.bottom).offset(24)
        }
        
        commentTableView.snp.remakeConstraints {
            $0.top.equalTo(seperateLine.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomContainerView.snp.top)
        }

        
        bottomContainerView.snp.makeConstraints {
            bottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).constraint
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        
        textFieldContainer.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
}
