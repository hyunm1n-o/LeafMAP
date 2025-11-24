//
//  TestView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit
import SnapKit
import Then

class TestView: UIView {
    //MARK: - Components
    lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    lazy var contentContainerView = UIView()
    
    lazy var questionsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
    }
    
    lazy var submitButton = AppButton(title: "검사 결과 보기").then {
        $0.isEnabled = false
        $0.backgroundColor = .gray1
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
        contentContainerView.addSubviews([questionsStackView, submitButton])
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        contentContainerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        questionsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(questionsStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
