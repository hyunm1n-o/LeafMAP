//
//  TestBoxView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit
import SnapKit
import Then

class TestBoxView: UIView {
    //MARK: - Properties
    var selectedScore: Int? {
        didSet {
            updateButtonStates()
        }
    }
    
    var onScoreSelected: ((Int) -> Void)?
    
    //MARK: - Components
    private lazy var questionLabel = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pSemiBold, size: 16)!,
        textColor: .gray900
    ).then {
        $0.numberOfLines = 0
    }
    
    private lazy var optionsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    private lazy var option5Button = createOptionButton(title: "매우 그렇다", score: 5)
    private lazy var option4Button = createOptionButton(title: "그렇다", score: 4)
    private lazy var option3Button = createOptionButton(title: "보통이다", score: 3)
    private lazy var option2Button = createOptionButton(title: "아니다", score: 2)
    private lazy var option1Button = createOptionButton(title: "전혀 아니다", score: 1)
    
    private var optionButtons: [UIButton] = []
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .boxGreen
        self.layer.cornerRadius = 12

        optionButtons = [option5Button, option4Button, option3Button, option2Button, option1Button]
        
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([questionLabel, optionsStackView])
        optionsStackView.addArrangedSubViews([
            option5Button,
            option4Button,
            option3Button,
            option2Button,
            option1Button
        ])
    }
    
    private func setConstraints() {
        questionLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        optionsStackView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
    
    //MARK: - Methods
    private func createOptionButton(title: String, score: Int) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.gray900, for: .normal)
            $0.setTitleColor(.white, for: .selected)
            $0.titleLabel?.font = UIFont(name: AppFontName.pRegular, size: 14)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray1.cgColor
            $0.tag = score
        }
        
        button.addTarget(self, action: #selector(didTapOption(_:)), for: .touchUpInside)
        
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        return button
    }
    
    @objc
    private func didTapOption(_ sender: UIButton) {
        selectedScore = sender.tag
        onScoreSelected?(sender.tag)
    }
    
    private func updateButtonStates() {
        optionButtons.forEach { button in
            if button.tag == selectedScore {
                button.isSelected = true
                button.backgroundColor = .green01
                button.layer.borderColor = UIColor.green01.cgColor
            } else {
                button.isSelected = false
                button.backgroundColor = .white
                button.layer.borderColor = UIColor.gray1.cgColor
            }
        }
    }
    
    func configure(question: String) {
        questionLabel.text = question
    }
}
