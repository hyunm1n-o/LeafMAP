//
//  StoreCollectionViewCell.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    static let identifier = "UICollectionViewCell"

    private lazy var storeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(storeImageView)
        storeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
