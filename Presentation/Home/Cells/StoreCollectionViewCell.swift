//
//  StoreCollectionViewCell.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit
import Kingfisher

class StoreCollectionViewCell: UICollectionViewCell {
    static let identifier = "UICollectionViewCell"
    
    private lazy var storeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .systemRed
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(storeImageView)
        storeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with imageUrl: String?) {
        guard let imageUrl = imageUrl,
              !imageUrl.isEmpty,
              let url = URL(string: imageUrl) else {
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
        ) { result in
            switch result {
            case .success:
                print("✅ 이미지 로드 성공: \(imageUrl)")
            case .failure(let error):
                print("❌ 이미지 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        storeImageView.kf.cancelDownloadTask()
        storeImageView.image = nil
    }
}
