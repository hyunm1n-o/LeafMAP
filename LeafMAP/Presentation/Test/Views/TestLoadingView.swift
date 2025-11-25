//
//  TestLoadingView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit
import Lottie
import SnapKit
import Then

class TestLoadingView: UIView {
    
    //MARK: - Components
    var loadingIndicator = LottieAnimationView(name: "LeafLoading").then {
        $0.loopMode = .loop
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var loadingLabel = AppLabel(
        text: "맞춤 전공 분석 중...",
        font: UIFont(name: AppFontName.pSemiBold, size: 24)!,
        textColor: .gray900
    )
    
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
        addSubviews([loadingIndicator, loadingLabel])
    }
    
    private func setConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(200)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.top.equalTo(loadingIndicator.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Loading Indicator Control
    func showLoadingIndicator() {
        loadingIndicator.isHidden = false
        if loadingIndicator.isAnimationPlaying == false {
            loadingIndicator.play()
        }
    }
    
    func hideLoadingIndicator() {
        if loadingIndicator.isAnimationPlaying {
            loadingIndicator.stop()
        }
        loadingIndicator.isHidden = true
    }
}
