//
//  ShopItemsViewController.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/25/25.
//

import UIKit
import Kingfisher
import SnapKit
import Alamofire

final class ShopItemsViewController: UIViewController {

    // MARK: - Identifier
    static let identifier = "ShopItemsViewController"
    
    // MARK: - Property
    var dataTitle: String = ""
    
    var data: Shop = Shop(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            configureUI()
        }
    }
    
    private lazy var items = data.items {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var recommendedItems: [ShopItem] = [] {
        didSet {
            recommendedCollectionView.reloadData()
        }
    }
    
    private var start = 1 {
        didSet {
            if start != 1 {
                NetworkManager.shared.callRequest(query: dataTitle, sort: sort, start: start, completionHandler: { data in
                    self.items.append(contentsOf: data.items)
                }, failHandler: requestFailHandler(title:message:))
            }
        }
    }
    
    private var sort = ShopItemSort.sim {
        didSet {
            start = 1
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            NetworkManager.shared.callRequest(query: dataTitle, sort: sort, completionHandler: { data in
                self.items = data.items
            }, failHandler: requestFailHandler(title:message:))
        }
    }
    
    private lazy var selectedButton: UIButton = sortByRelevanceButton {
        didSet {
            oldValue.isSelected = false
            selectedButton.isSelected = true
            
            switch selectedButton.tag {
            case 0:
                sort = ShopItemSort.sim
            case 1:
                sort = ShopItemSort.date
            case 2:
                sort = ShopItemSort.dsc
            case 3:
                sort = ShopItemSort.asc
            default:
                break
            }
        }
    }
    
    // MARK: - Conponent
    private let countLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGreen
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var sortByRelevanceButton = {
        let button = SelectableButton("정확도순")
        button.isSelected = true
        button.tag = 0
        button.addTarget(self, action: #selector(sortByButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortByLatestButton = {
        let button = SelectableButton("날짜순")
        button.tag = 1
        button.addTarget(self, action: #selector(sortByButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortByHighPriceButton = {
        let button = SelectableButton("가격높은순")
        button.tag = 2
        button.addTarget(self, action: #selector(sortByButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortByLowPriceButton = {
        let button = SelectableButton("가격낮은순")
        button.tag = 3
        button.addTarget(self, action: #selector(sortByButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ShopItemCollectionViewCell.self, forCellWithReuseIdentifier: ShopItemCollectionViewCell.identifier)
        
        collectionView.indicatorStyle = .white
        collectionView.tag = 0
        return collectionView
    }()
    
    private lazy var recommendedCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout(rowCount: 3, direction: .horizontal))
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ShopItemCollectionViewCell.self, forCellWithReuseIdentifier: ShopItemCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemMint
        collectionView.tag = 1
        return collectionView
    }()
    
    private var activityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .medium
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        activityIndicatorView.backgroundColor = .black
        return activityIndicatorView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuerHierarchy()
        configureLayout()
        initUI()
        configure()
        
        NetworkManager.shared.callRequest(query: "캠핑", completionHandler: { data in
            self.recommendedItems = data.items
            self.activityIndicatorView.stopAnimating()
        }, failHandler: requestFailHandler(title:message:))
    }
    
    // MARK: - Method
    private func collectionViewLayout(_ layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(), rowCount: CGFloat = 2, padding: CGFloat = 8, spacing: CGFloat = 8, direction: UICollectionView.ScrollDirection = .vertical) -> UICollectionViewFlowLayout {
        let itemRowCount = rowCount
        
        let edgePadding = padding
        let itemSpacing = spacing
        
        let deviceWidth = UIScreen.main.bounds.width
        
        let itemWidth = deviceWidth - (edgePadding * 2) - (itemSpacing * (itemRowCount - 1))
        
        layout.itemSize = CGSize(width: itemWidth / itemRowCount, height: (itemWidth / itemRowCount) + 88)
        layout.sectionInset = .init(top: edgePadding, left: edgePadding, bottom: edgePadding, right: edgePadding)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.scrollDirection = direction
        
        return layout
    }
    
    private func requestFailHandler(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message) { _ in }
        present(alert, animated: true)
    }
    
    @objc private func sortByButtonTapped(sender: UIButton) {
        selectedButton = sender
    }
}

extension ShopItemsViewController: SeSACViewControllerProtocol {
    
    // MARK: - Configure Hierarchy
    func configuerHierarchy() {
        view.addSubview(countLabel, sortByRelevanceButton, sortByLatestButton, sortByHighPriceButton, sortByLowPriceButton, collectionView, recommendedCollectionView, activityIndicatorView)
    }
    
    // MARK: - Configure Layout
    func configureLayout() {
        configureCountLabelLayout()
        configureSortByRelevanceButton()
        configureSortByLatestButton()
        configureSortByHighPriceButton()
        configureSortByLowPriceButton()
        configureCollectionViewLayout()
        configureRecommendedCollectionViewLayout()
        configureActivityIndicatorViewLayout()
    }
    
    private func configureCountLabelLayout() {
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func configureSortByRelevanceButton() {
        sortByRelevanceButton.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
    }
    
    private func configureSortByLatestButton() {
        sortByLatestButton.snp.makeConstraints { make in
            make.centerY.equalTo(sortByRelevanceButton)
            make.leading.equalTo(sortByRelevanceButton.snp.trailing).offset(8)
        }
    }
    
    private func configureSortByHighPriceButton() {
        sortByHighPriceButton.snp.makeConstraints { make in
            make.centerY.equalTo(sortByRelevanceButton)
            make.leading.equalTo(sortByLatestButton.snp.trailing).offset(8)
        }
    }
    
    private func configureSortByLowPriceButton() {
        sortByLowPriceButton.snp.makeConstraints { make in
            make.centerY.equalTo(sortByRelevanceButton)
            make.leading.equalTo(sortByHighPriceButton.snp.trailing).offset(8)
        }
    }
    
    private func configureCollectionViewLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortByRelevanceButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(recommendedCollectionView.snp.top)
        }
    }
    
    private func configureRecommendedCollectionViewLayout() {
        recommendedCollectionView.snp.makeConstraints { make in
            make.height.equalTo(220)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureActivityIndicatorViewLayout() {
        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Configure UI
    func configureUI() {
        configureCountLabelUI()
    }
    
    private func configureCountLabelUI() {
        countLabel.text = "\(String(data.total).toDecimalStyle()) 개의 검색 결과"
    }
    
    // MARK: - Initialize UI
    func initUI() {
        initViewUI()
    }
    
    private func initViewUI() {
        navigationItem.title = dataTitle
        view.backgroundColor = .black
        collectionView.backgroundColor = .clear
    }
    
    // MARK: - Configure
    func configure() {
        
    }
}


extension ShopItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - CollectionView Delegate, DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return items.count
        case 1:
            return recommendedItems.count
        default: break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemCollectionViewCell.identifier, for: indexPath) as! ShopItemCollectionViewCell
        
        switch collectionView.tag {
        case 0:
            let row = items[indexPath.row]
            
            cell.backgroundColor = .clear
            cell.configureUI(rowData: row)
        case 1:
            let row = recommendedItems[indexPath.row]
            
            cell.backgroundColor = .clear
            cell.configureUI(rowData: row)
        default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(#function, indexPath)
        if !(collectionView.tag == 0) { return }
        
        let checkCount = indexPath.row + 1
        let preloadThreshold = items.count - ShopItemPrefetchConfig.preloadThreshold.rawValue
        
        // 데이터 추가
        if checkCount == preloadThreshold {
            // 마지막 페이지 확인
            let startItemCount = start + ShopItemPrefetchConfig.display.rawValue
            let maxItemCount = ShopItemPrefetchConfig.maxItemCount.rawValue
            if startItemCount > min(data.total, maxItemCount) {
                print("마지막 페이지")
                return
            }
            start = startItemCount
        }
    }
}
