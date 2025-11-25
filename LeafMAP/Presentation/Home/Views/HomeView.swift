//
//  HomeView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class HomeView: UIView {
    //MARK: - Properties
    public var name: String = "" {
        didSet {
            updateGreetingLabel()
        }
    }
    
    public var major: String = "" {
        didSet {
            sub.text = major
        }
    }
    
    // 맛집 이미지 데이터
    public var restaurantPosts: [RestaurantPostPreviewDTO] = [] {
        didSet {
            storeCollectionView.reloadData()
        }
    }
    
    //MARK: - Components
    private lazy var greetingLabel = AppLabel(text: "\(name)님, 반가워요! 🌱",
                                              font: UIFont(name: AppFontName.pSemiBold, size: 24)!,
                                              textColor: .gray900).then {
        let targetString = "\(name)"
        $0.asColor(targetString: targetString, color: .green02)
        $0.textAlignment = .left
    }
    
    private lazy var sub = AppLabel(text: "\(major)",
                                    font: UIFont(name: AppFontName.pMedium, size: 16)!,
                                    textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    public var editInfoButton = SmallTextButton(title: "정보 수정하기")
    
    // - 서경 꿀팁 모아보기
    private lazy var firstLabel = AppLabel(text: "서경꿀팁 모아보기💡",
                                           font: UIFont(name: AppFontName.pSemiBold, size: 16)!,
                                           textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    private lazy var tipHorizonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    private lazy var tipTwoHorizonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
        
    }
    
    public let majorSelectTipView = SquareView(title: "학과별 선택 꿀팁",
                                               sub: "전공 고르기, 아무거나 금지")
    
    public let shortLoadTipView = SquareView(title: "지름길 보기",
                                             sub: "폭염엔 이 길이 무조건 국룰!")
    
    public let useTipView = SquareView(title: "교내시설 이용방법",
                                       sub: "프린터기 사용법은\n왜 매번 까먹을까?")
    
    public let schoolTipView = SquareView(title: "학교 생활 꿀팁",
                                          sub: "이걸 보면\n서경생활 100레벨 달성")
    
    // - 근처 맛집 둘러보기
    private lazy var secondLabel = AppLabel(text: "근처 맛집 둘러보기🍽️",
                                            font: UIFont(name: AppFontName.pSemiBold, size: 16)!,
                                            textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    public lazy var storeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 16
        $0.scrollDirection = .horizontal
    }).then {
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.identifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // - 나의 풀잎
    private lazy var thirdLabel = AppLabel(text: "나의 풀잎 🍃",
                                           font: UIFont(name: AppFontName.pSemiBold, size: 16)!,
                                           textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    public lazy var homeTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    public lazy var chatBotButton = UIButton().then {
        $0.setImage(UIImage(named: "chatbot"), for: .normal)
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
    private func updateGreetingLabel() {
        let fullText = "\(name)님, 반가워요!🌱"
        greetingLabel.text = fullText
        greetingLabel.asColor(targetString: name, color: .green02)
    }
    
    private func setView() {
        addSubviews([greetingLabel, sub, editInfoButton, firstLabel, tipHorizonStackView, tipTwoHorizonStackView, secondLabel, storeCollectionView, thirdLabel, homeTableView, chatBotButton])
        tipHorizonStackView.addArrangedSubViews([majorSelectTipView, shortLoadTipView])
        tipTwoHorizonStackView.addArrangedSubViews([useTipView, schoolTipView])
    }
    
    private func setConstraints() {
        greetingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.leading.equalToSuperview().inset(24)
        }
        
        sub.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
        
        editInfoButton.snp.makeConstraints {
            $0.centerY.equalTo(sub)
            $0.leading.equalTo(sub.snp.trailing).offset(8)
        }
        
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(sub.snp.bottom).offset(44)
            $0.leading.equalToSuperview().inset(24)
        }
        
        tipHorizonStackView.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        tipTwoHorizonStackView.snp.makeConstraints {
            $0.top.equalTo(tipHorizonStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        secondLabel.snp.makeConstraints {
            $0.top.equalTo(tipTwoHorizonStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        storeCollectionView.snp.makeConstraints {
            $0.top.equalTo(secondLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        thirdLabel.snp.makeConstraints {
            $0.top.equalTo(storeCollectionView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        homeTableView.snp.makeConstraints {
            $0.top.equalTo(thirdLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44 * 3)
        }
        
        chatBotButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        
    }
}
