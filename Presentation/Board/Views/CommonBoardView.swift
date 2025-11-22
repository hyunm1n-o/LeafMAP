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
        addSubviews([postTableView, writeButton])
    }
    
    private func setConstraints() {
        postTableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
