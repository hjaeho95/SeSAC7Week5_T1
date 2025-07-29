//
//  ShopViewController.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/25/25.
//

import UIKit
import Alamofire
import SnapKit
import Toast

final class ShopViewController: UIViewController {
    
    // MARK: - Identifier
    static let identifier = "ShopViewController"
    
    // MARK: - Property
    private var query: String = "" {
        didSet {
            NetworkManager.shared.callRequest(query: query) { data in
                self.data = data
            }
        }
    }
    
    private var data: Shop = Shop(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            navigateToShowItemsViewController(data)
        }
    }
    
    // MARK: - Component
    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSMutableAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [
            .foregroundColor: UIColor.systemGray.cgColor,
        ])
        searchBar.searchTextField.leftView?.tintColor = .systemGray
        
        searchBar.barTintColor = .clear
        
        searchBar.delegate = self
        return searchBar
    }()
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        return imageView
    }()
    
    private let label = {
        let label = UILabel()
        label.text = "쇼핑하구팡"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
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
    private func navigateToShowItemsViewController(_ data: Shop) {
        let viewController = ShopItemsViewController()
        viewController.dataTitle = query
        viewController.data = data
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ShopViewController: SeSACViewControllerProtocol {
    // MARK: - Configure Hierarchy
    func configuerHierarchy() {
        view.addSubview(searchBar, imageView, label)
    }
    
    // MARK: - Configure Layout
    func configureLayout() {
        configureSearchBarLayout()
        configureImageViewLayout()
        configureLabelLayout()
    }
    
    private func configureSearchBarLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureImageViewLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(200)
        }
    }
    
    private func configureLabelLayout() {
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Configure UI
    func configureUI() {
        
    }
    
    // MARK: - Initialize UI
    func initUI() {
        initViewUI()
    }
    
    private func initViewUI() {
        view.backgroundColor = .black
        navigationItem.title = "영캠러의 쇼핑쇼핑"
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - Configure
    func configure() {
        
    }
}

extension ShopViewController: UISearchBarDelegate {
    // MARK: - SearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 1 else {
            let alert = UIAlertController(title: "", message: "2글자 이상 입력해주세요!") { _ in
                searchBar.text = ""
            }
            present(alert, animated: true)
            return
        }
        query = text
    }
}

extension ShopViewController {
    // MARK: - Touch Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
