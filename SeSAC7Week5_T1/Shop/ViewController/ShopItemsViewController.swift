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

enum ShopItemSort: String {
    case sim = "sim"
    case date = "date"
    case dsc = "dsc"
    case asc = "asc"
}

class ShopItemsViewController: UIViewController {

    // MARK: - Identifier
    static let identifier = "ShopItemsViewController"
    
    // MARK: - Property
    var dataTitle: String = ""
    var data: Shop = Shop(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            print("data")
            collectionView.reloadData()
        }
    }
    lazy var selectedButton: UIButton = sortByRelevanceButton {
        didSet {
            oldValue.isSelected = false
            selectedButton.isSelected = true
            
            switch selectedButton.tag {
            case 0:
                callRequest(sort: ShopItemSort.sim.rawValue)
            case 1:
                callRequest(sort: ShopItemSort.date.rawValue)
            case 2:
                callRequest(sort: ShopItemSort.dsc.rawValue)
            case 3:
                callRequest(sort: ShopItemSort.asc.rawValue)
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
    
    private func callRequest(sort: String) {
        print(#function)
        let headers = HTTPHeaders([
            "X-Naver-Client-Id": "HoBtSpz61437_fassXHE",
            "X-Naver-Client-Secret": "uhRjQxAq8s"
        ])
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(dataTitle)&display=100&sort=\(sort)"
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: Shop.self) { response in
                switch response.result {
                case .success(let data):
                    self.data = data
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    @objc private func sortByButtonTapped(sender: UIButton) {
        selectedButton = sender
    }
}

extension ShopItemsViewController: SeSACViewControllerProtocol {
    
    // MARK: - Configure Hierarchy
    func configuerHierarchy() {
        view.addSubview(countLabel, sortByRelevanceButton, sortByLatestButton, sortByHighPriceButton, sortByLowPriceButton, collectionView)
    }
    
    // MARK: - Configure Layout
    func configureLayout() {
        configureCountLabelLayout()
        configureSortByRelevanceButton()
        configureSortByLatestButton()
        configureSortByHighPriceButton()
        configureSortByLowPriceButton()
        configureCollectionViewLayout()
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
