//
//  MajorTipView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/24/25.
//

import UIKit
import Kingfisher
import SnapKit

class MajorTipView: UIView {
    //MARK: - Properties
    public var hopeMajor: String = "" {
        didSet {
            hopeMajorLabel.text = "나의 희망학과: \(hopeMajor)"
        }
    }
    
    public var bottomConstraint: Constraint?
    
    //MARK: - Components
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    private lazy var contentContainerView = UIView()
    
    private lazy var hopeMajorLabel = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pMedium, size: 16)!,
        textColor: .gray900
    )
    
    public lazy var editButton = SmallTextButton(title: "내 희망학과 수정하기")
    
    //MARK: 핵심키워드
    private lazy var firstView = makeBoxView()
    private lazy var firstTitle = makeTitleLabel(text: "핵심 키워드 🌱")
    private lazy var keywordLabel = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pRegular, size: 16)!,
        textColor: .gray900
    ).then {
        $0.numberOfLines = 0
    }
    
    private lazy var divideLine = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private lazy var descLabel = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pRegular, size: 14)!,
        textColor: .gray900
    ).then {
        $0.numberOfLines = 0
    }
    
    //MARK: 이수체계도
    private lazy var secondView = makeBoxView()
    private lazy var secondTitle = makeTitleLabel(text: "이수체계도 ✍🏻")
    private lazy var curriculumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray1
    }
    
    //MARK: 졸업후진로
    private lazy var thirdView = makeBoxView()
    private lazy var thirdTitle = makeTitleLabel(text: "졸업 후 진로 🧑🏻‍💻")
    private lazy var jobLabel = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pRegular, size: 14)!,
        textColor: .gray900
    ).then {
        $0.numberOfLines = 0
    }
    
    //MARK: 댓글
    private lazy var commentTitleView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.disable.cgColor
    }
    
    private lazy var commentTitleLabel = AppLabel(
        text: "서경인의 리얼 전공토크, 지금 바로 참여해 보세요",
        font: UIFont(name: AppFontName.pMedium, size: 16)!,
        textColor: .gray900
    ).then {
        $0.numberOfLines = 0
    }
    
    public lazy var commentTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    //MARK: 답글 바
    private lazy var replyBarContainer = UIView().then {
        $0.backgroundColor = .gray1
        $0.isHidden = true
    }
    
    private lazy var replyLabel = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pRegular, size: 14)!,
        textColor: .gray
    )
    
    public lazy var cancelReplyButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .gray
    }
    
    //MARK: 하단 댓글 입력창
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
    
    // MARK: - Factory Methods
    private func makeBoxView() -> UIView {
        return UIView().then {
            $0.backgroundColor = .boxGreen
            $0.layer.cornerRadius = 12
        }
    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        return AppLabel(
            text: text,
            font: UIFont(name: AppFontName.pSemiBold, size: 20)!,
            textColor: .gray900
        )
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
    
    //MARK: - SetUI
    private func setView() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainerView)
        
        contentContainerView.addSubviews([
            hopeMajorLabel,
            editButton,
            firstView,
            secondView,
            thirdView,
            commentTitleView,
            commentTableView
        ])
        
        firstView.addSubviews([firstTitle, keywordLabel, divideLine, descLabel])
        secondView.addSubviews([secondTitle, curriculumImageView])
        thirdView.addSubviews([thirdTitle, jobLabel])
        commentTitleView.addSubview(commentTitleLabel)
        
        addSubview(replyBarContainer)
        replyBarContainer.addSubviews([replyLabel, cancelReplyButton])
        
        addSubview(bottomContainerView)
        bottomContainerView.addSubview(textFieldContainer)
        textFieldContainer.addSubviews([commentTextField, sendButton])
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(replyBarContainer.snp.top)
        }
        
        contentContainerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        hopeMajorLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(hopeMajorLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.leading.greaterThanOrEqualTo(hopeMajorLabel.snp.trailing).offset(8)
        }
        
        firstView.snp.makeConstraints {
            $0.top.equalTo(hopeMajorLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        firstTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(firstTitle.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        secondView.snp.makeConstraints {
            $0.top.equalTo(firstView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        secondTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        curriculumImageView.snp.makeConstraints {
            $0.top.equalTo(secondTitle.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        thirdView.snp.makeConstraints {
            $0.top.equalTo(secondView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        thirdTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        jobLabel.snp.makeConstraints {
            $0.top.equalTo(thirdTitle.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        commentTitleView.snp.makeConstraints {
            $0.top.equalTo(thirdView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        commentTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(commentTitleView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0) // 동적 업데이트
            $0.bottom.equalToSuperview().inset(16)
        }
        
        replyBarContainer.snp.makeConstraints {
            $0.bottom.equalTo(bottomContainerView.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        replyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        cancelReplyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            bottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).constraint
            $0.height.equalTo(76)
        }
        
        textFieldContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(commentTextField.snp.trailing).offset(8)
            $0.size.equalTo(24)
        }
    }
    
    //MARK: - Configure
    func configure(
        hopeMajor: String,
        keywords: String,
        description: String,
        curriculumUrl: String?,
        career: String
    ) {
        self.hopeMajor = hopeMajor
        
        //  키워드를 #으로 분리하여 표시
        let keywordArray = keywords.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let formattedKeywords = keywordArray.map { "#\($0)" }.joined(separator: " ")
        keywordLabel.text = formattedKeywords
        
        descLabel.text = description
        jobLabel.text = career
        
        // 이수체계도 이미지 로드
        if let urlString = curriculumUrl, let url = URL(string: urlString) {
            curriculumImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
    }
    
    //  답글 모드 설정
    func setReplyMode(isActive: Bool, parentAuthor: String) {
        replyBarContainer.isHidden = !isActive
        if isActive {
            replyLabel.text = "\(parentAuthor)님에게 답글 작성 중..."
            commentTextField.placeholder = "답글을 입력하세요"
        } else {
            commentTextField.placeholder = "댓글을 입력하세요"
        }
    }
}
