//
//  NetworkManager.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/28/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    private init() { }
    
    static let shared = NetworkManager()
    
    private let url = "https://openapi.naver.com/v1/search/shop.json?"
    private let headers = HTTPHeaders([
        "X-Naver-Client-Id": APIKey.naverClientId,
        "X-Naver-Client-Secret": APIKey.naverClientSecret
    ])
     
    func callRequest(query: String, display: Int = ShopItemPrefetchConfig.display.rawValue, sort: ShopItemSort = ShopItemSort.sim, start: Int = 1, completionHandler: @escaping (Shop) -> Void, failHandler: @escaping (String, String) -> Void) {
        print(#function)
        
        if !NetworkMonitor.shared.isConnected {
            failHandler("Error", "인터넷 연결 실패")
            return
        }
        
        let url = "\(url)qery=\(query)&display=\(display)&sort=\(sort.rawValue)&start=\(start)"
        let headers = headers
        AF.request(url, method: .get, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    guard let response = response.response else { return }
                    if (200..<300).contains(response.statusCode) {
                        do {
                            let result = try JSONDecoder().decode(Shop.self, from: data)
                            completionHandler(result)
                        } catch {
                            print("디코딩 실패: \(error)")
                            failHandler("Error", "디코딩 실패")
                        }
                    } else {
                        do {
                            let result = try JSONDecoder().decode(NaverError.self, from: data)
                            print("상태 코드: \(response.statusCode)")
                            print("에러: \(result)")
                            failHandler("\(response.statusCode) Error", "\(result.errorCode): \(result.errorMessage)")
                        } catch {
                            print("디코딩 실패: \(error)")
                            failHandler("Error", "디코딩 실패")
                        }
                    }
                case .failure(let error):
                    print("Alamofire error: \(error)")
                    failHandler("Error", "Alamofire error")
                }
            }
    }
}
