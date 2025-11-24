//
//  StoreDetailView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/21/25.
//

import UIKit
import Kingfisher

class StoreDetailView: UIView {
    //MARK: - Components
    private lazy var storeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 12
    }
    
    private lazy var storeNameLabel = AppLabel(text: "",
                                           font: UIFont(name: AppFontName.pSemiBold, size: 22)!,
                                           textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    private lazy var storeLocationLabel = AppLabel(text: "",
                                               font: UIFont(name: AppFontName.pRegular, size: 16)!,
                                               textColor: .gray).then {
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
    
    //MARK: - Configure
    public func configure(
        title: String,
        address: String?,
        imageUrl: String?,
        likeCount: Int,
        isLiked: Bool
    ) {
        storeNameLabel.text = title
        
        if let address = address, !address.isEmpty {
            storeLocationLabel.text = "📍 \(address)"
        } else {
            storeLocationLabel.text = "주소 정보 없음"
        }
        
        recommendButton.isSelected = isLiked
        recommendLabel.text = "추천하기 (\(likeCount))"
        
        // 이미지 로드
        loadImage(from: imageUrl)
    }
    
    private func loadImage(from urlString: String?) {
        guard let urlString = urlString,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            storeImageView.image = nil
            storeImageView.backgroundColor = .gray1
            return
        }
        
        storeImageView.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                print(" 맛집 이미지 로드 성공")
                
                //  이미지 비율에 맞춰 높이 조정
                let image = value.image
                let imageWidth = UIScreen.main.bounds.width - 48
                let imageRatio = image.size.height / image.size.width
                let calculatedHeight = imageWidth * imageRatio
                let finalHeight = min(calculatedHeight, 300)  // 최대 300
                
                self.storeImageView.snp.remakeConstraints {
                    $0.top.equalTo(self.safeAreaLayoutGuide).inset(40)
                    $0.horizontalEdges.equalToSuperview().inset(24)
                    $0.height.equalTo(finalHeight)
                }
                
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                }
                
            case .failure(let error):
                print("❌ 맛집 이미지 로드 실패: \(error.localizedDescription)")
                self.storeImageView.image = nil
                self.storeImageView.backgroundColor = .gray1
            }
        }
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([storeImageView, storeNameLabel, storeLocationLabel, recommendButton, recommendLabel])
    }
    
    private func setConstraints() {
        storeImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(storeImageView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        storeLocationLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
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
    
    //MARK: - Helpers
    func updateLikeCount(_ count: Int) {
        recommendLabel.text = "추천하기 (\(count))"
    }
}
