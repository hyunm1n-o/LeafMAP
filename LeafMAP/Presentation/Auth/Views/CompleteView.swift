//
//  CompleteView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class CompleteView: UIView {
    //MARK: - Components
    private lazy var skonImageView = UIImageView().then {
        $0.image = UIImage(named: "skon")
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var title = AppLabel(text: "풀잎이가 된 걸\n환영해요!",
                                      font: UIFont(name: AppFontName.pSemiBold, size: 32)!,
                                      textColor: .gray900).then {
        let targetString = "풀잎"
        $0.asColor(targetString: targetString, color: .green02)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    public lazy var startButton = AppButton(title: "시작하기")

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
        addSubviews([title, skonImageView, startButton])
    }
    
    private func setConstraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(78)
            $0.leading.equalToSuperview().inset(24)
        }
        
        skonImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
