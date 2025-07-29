//
//  NetworkManager.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/28/25.
//

import Alamofire
import UIKit

final class NetworkManager {
    
    private init() { }
    
    static let shared = NetworkManager()
    
    let url = "https://openapi.naver.com/v1/search/shop.json?"
    let headers = HTTPHeaders([
        "X-Naver-Client-Id": APIKey.naverClientId,
        "X-Naver-Client-Secret": APIKey.naverClientSecret
    ])
     
    func callRequest(query: String, view: UIViewController, display: Int = ShopItemPrefetchConfig.display.rawValue, sort: ShopItemSort = ShopItemSort.sim, start: Int = 1, completionHandler: @escaping (Shop) -> Void) {
        print(#function)
        
        if !NetworkMonitor.shared.isConnected {
            let alert = UIAlertController(title: "Error", message: "인터넷 연결 실패") { _ in }
            view.present(alert, animated: true)
            return
        }
        
        let url = "\(url)qury=\(query)&display=\(display)&sort=\(sort.rawValue)&start=\(start)"
        let headers = headers
        AF.request(url, method: .get, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let response = response.response {
                        if (200..<300).contains(response.statusCode) {
                            do {
                                let result = try JSONDecoder().decode(Shop.self, from: data)
                                print("성공: \(result)")
                            } catch {
                                print("디코딩 실패: \(error)")
                                let alert = UIAlertController(title: "Error", message: "디코딩 실패") { _ in }
                                view.present(alert, animated: true)
                            }
                        } else {
                            do {
                                let result = try JSONDecoder().decode(NaverError.self, from: data)
                                print("상태 코드: \(response.statusCode)")
                                print("에러: \(result)")
                                let alert = UIAlertController(title: "\(response.statusCode) Error", message: "\(result.errorCode): \(result.errorMessage)") { _ in }
                                view.present(alert, animated: true)
                            } catch {
                                print("디코딩 실패: \(error)")
                                let alert = UIAlertController(title: "Error", message: "디코딩 실패") { _ in }
                                view.present(alert, animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    print("Alamofire error: \(error)")
                    let alert = UIAlertController(title: "Error", message: "Alamofire error") { _ in }
                    view.present(alert, animated: true)
                }
            }
    }
}
