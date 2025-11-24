//
//  TestCompleteView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit
import SnapKit
import Then

class TestCompleteView: UIView {
    
    //MARK: - Properties
    private let majorName: String
    
    //MARK: - Components
    private lazy var resultLabel = AppLabel(
        text: "성향에 가장 잘 맞는 학과는\n\(majorName) 입니다",
        font: UIFont(name: AppFontName.pSemiBold, size: 24)!,
        textColor: .gray900
    ).then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        let targetString = majorName
        $0.asColor(targetString: targetString, color: .green02)
    }
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "skon")
        $0.contentMode = .scaleAspectFit
    }
    
    public lazy var moreButton = AppButton(title: "\(majorName)에 대해 더 자세히 알아보기!")
    
    //MARK: - init
    init(majorName: String) {
        self.majorName = majorName
        super.init(frame: .zero)
        self.backgroundColor = .white
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([imageView, resultLabel, moreButton])
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(200)
        }
        
        resultLabel.snp.makeConstraints {
            $0.bottom.equalTo(imageView.snp.top).offset(-32)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        moreButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }
}
