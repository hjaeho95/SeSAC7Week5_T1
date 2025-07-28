//
//  ShopItemCollectionViewCell.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/25/25.
//

import UIKit
import Kingfisher
import SnapKit

final class ShopItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "ShopItemCollectionViewCell"
    
    // MARK: - Property
    private var isLike = false {
        didSet {
            isLike ? itemLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : itemLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            
        }
    }
    
    // MARK: - Component
    private let itemImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private lazy var itemLikeButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .black
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(itemLikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let itemMallNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let itemTitleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let itemlpriceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuerHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    @objc func itemLikeButtonTapped() {
        isLike.toggle()
    }
}

extension ShopItemCollectionViewCell: SeSACViewCellProtocol {
    // MARK: - Configure Hierarchy
    func configuerHierarchy() {
        contentView.addSubview(itemImageView, itemLikeButton, itemMallNameLabel, itemTitleLabel, itemlpriceLabel)
    }
    
    // MARK: - Configure Layout
    func configureLayout() {
        configureItemImageViewLayout()
        configureItemLikeButtonLayout()
        configureItemMallNameLabelLayout()
        configureItemTitleLabelLayout()
        configureIitemlpriceLabelLayout()
    }
    
    private func configureItemImageViewLayout() {
        itemImageView.snp.makeConstraints{ make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(150)
        }
    }
    
    private func configureItemLikeButtonLayout() {
        itemLikeButton.snp.makeConstraints{ make in
            make.bottom.trailing.equalTo(itemImageView).inset(16)
            make.size.equalTo(32)
        }
    }
    
    private func configureItemMallNameLabelLayout() {
        itemMallNameLabel.snp.makeConstraints{ make in
            make.top.equalTo(itemImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(4)
        }
    }
    
    private func configureItemTitleLabelLayout() {
        itemTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(itemMallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(4)
        }
    }
    
    private func configureIitemlpriceLabelLayout() {
        itemlpriceLabel.snp.makeConstraints{ make in
            make.top.equalTo(itemTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(4)
        }
    }
    
    // MARK: - Configure UI
    func configureUI(rowData: ShopItem) {
        configureItemImageViewUI(rowData.image)
        configureItemLikeButtonUI()
        configureItemMallNameLabelUI(rowData.mallName)
        configureItemTitleLabelUI(rowData.title)
        configureIitemlpriceLabelUI(rowData.lprice)
    }
    
    private func configureItemImageViewUI(_ image: String) {
        let imageUrl = URL(string: image)
        itemImageView.kf.setImage(with: imageUrl)
    }
    
    private func configureItemLikeButtonUI() {
        
    }
    
    private func configureItemMallNameLabelUI(_ text: String) {
        itemMallNameLabel.text = text
    }
    
    private func configureItemTitleLabelUI(_ text: String) {
        itemTitleLabel.text = text
    }
    
    private func configureIitemlpriceLabelUI(_ text: String) {
        itemlpriceLabel.text = "\(text.toDecimalStyle())원"
    }
}
