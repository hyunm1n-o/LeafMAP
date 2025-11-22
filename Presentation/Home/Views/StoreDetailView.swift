//
//  StoreDetailView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/21/25.
//

import UIKit

class StoreDetailView: UIView {
    //MARK: - Properties
    
    //MARK: - Components
    private lazy var storeImageView = UIImageView().then {
        $0.image = UIImage(named: "")
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 12
    }
    
    private lazy var storeNameLabel = AppLabel(text: "경성 마라탕",
                                           font: UIFont(name: AppFontName.pSemiBold, size: 22)!,
                                           textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    private lazy var storeTimeLabel = AppLabel(text: "00:00 - 11:00",
                                               font: UIFont(name: AppFontName.pRegular, size: 16)!,
                                               textColor: .gray).then {
        $0.textAlignment = .left
    }
    
    private lazy var storeLocationLabel = AppLabel(text: "서울시 성북구 서경로 12. 층",
                                               font: UIFont(name: AppFontName.pRegular, size: 16)!,
                                               textColor: .gray).then {
        $0.textAlignment = .left
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
        addSubviews([storeImageView, storeNameLabel, storeTimeLabel, storeLocationLabel, recommendButton, recommendLabel])
    }
    
    private func setConstraints() {
        storeImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(storeImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        storeTimeLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        storeLocationLabel.snp.makeConstraints {
            $0.top.equalTo(storeTimeLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        recommendButton.snp.makeConstraints {
            $0.top.equalTo(storeLocationLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        recommendLabel.snp.makeConstraints {
            $0.centerY.equalTo(recommendButton)
            $0.leading.equalTo(recommendButton.snp.trailing).offset(4)
        }
    }
}
