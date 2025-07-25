//
//  ShopItemsViewController.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/25/25.
//

import UIKit
import Kingfisher
import SnapKit

class ShopItemsViewController: UIViewController {

    // MARK: - Identifier
    static let identifier = "ShopItemsViewController"
    
    // MARK: - Property
    var dataTitle: String = ""
    var data: Shop = Shop(lastBuildDate: "", total: 0, start: 0, display: 0, items: [])
    
    // MARK: - Conponent
    private let countLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGreen
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ShopItemCollectionViewCell.self, forCellWithReuseIdentifier: ShopItemCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuerHierarchy()
        configureLayout()
        initUI()
        configure()
    }
    
    // MARK: - Method
    private func collectionViewLayout(_ layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(), rowCount: CGFloat = 2, padding: CGFloat = 8, spacing: CGFloat = 8, direction: UICollectionView.ScrollDirection = .vertical) -> UICollectionViewFlowLayout {
        let itemRowCount = rowCount
        
        let edgePadding = padding
        let itemSpacing = spacing
        
        let deviceWidth = UIScreen.main.bounds.width
        
        let itemWidth = deviceWidth - (edgePadding * 2) - (itemSpacing * (itemRowCount - 1))
        
        layout.itemSize = CGSize(width: itemWidth / itemRowCount, height: 240)
        layout.sectionInset = .init(top: edgePadding, left: edgePadding, bottom: edgePadding, right: edgePadding)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.scrollDirection = direction
        
        return layout
    }
}

extension ShopItemsViewController: SeSACViewControllerProtocol {
    
    // MARK: - Configure Hierarchy
    func configuerHierarchy() {
        view.addSubview(countLabel, collectionView)
    }
    
    // MARK: - Configure Layout
    func configureLayout() {
        configureCountLabelLayout()
        configureCollectionViewLayout()
    }
    
    private func configureCountLabelLayout() {
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func configureCollectionViewLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }
    
    // MARK: - Configure UI
    func configureUI() {
        
    }
    
    // MARK: - Initialize UI
    func initUI() {
        initViewUI()
        initCountLabelUI()
    }
    
    private func initViewUI() {
        navigationItem.title = dataTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white.cgColor]
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .black
        collectionView.backgroundColor = .clear
    }
    
    private func initCountLabelUI() {
        countLabel.text = "\(String(data.total).toDecimalStyle()) 개의 검색 결과"
    }
    
    // MARK: - Configure
    func configure() {
        
    }
}

extension ShopItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemCollectionViewCell.identifier, for: indexPath) as! ShopItemCollectionViewCell
        
        let row = data.items[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.configureUI(rowData: row)
        
        return cell
    }
}
