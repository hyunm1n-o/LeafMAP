//
//  CommonBoardView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/21/25.
//

import UIKit

class CommonBoardView: UIView {
    //MARK: - Components
    public lazy var postTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = true
        $0.isScrollEnabled = true
        $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
    }
    
    public lazy var writeButton = UIButton().then {
        $0.setImage(UIImage(named: "add"), for: .normal)
    }
    
    public lazy var hopeMajorButton = UIButton().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .green01
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("내 희망학과 바로가기", for: .normal)
        $0.isHidden = true
        $0.titleLabel?.font = UIFont(name: AppFontName.pMedium, size: 14)
        
        $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
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
        addSubviews([postTableView, writeButton, hopeMajorButton])
    }
    
    private func setConstraints() {
        postTableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        hopeMajorButton.snp.makeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }
    
    // MARK: - Helpers
    func setMajorList(_ hidden: Bool) {
        writeButton.isHidden = !hidden
        hopeMajorButton.isHidden = hidden
    }
}
