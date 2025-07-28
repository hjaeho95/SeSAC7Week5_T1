//
//  NetworkManager.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/28/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    var url = "https://openapi.naver.com/v1/search/shop.json?"
    var headers = HTTPHeaders([
        "X-Naver-Client-Id": "HoBtSpz61437_fassXHE",
        "X-Naver-Client-Secret": "uhRjQxAq8s"
    ])
     
    func callRequest(query: String, display: Int = ShopItemPrefetchConfig.display.rawValue, sort: ShopItemSort = ShopItemSort.sim, start: Int = 1, handler: @escaping (Shop) -> Void) {
        print(#function)
        let url = "\(url)query=\(query)&display=\(display)&sort=\(sort.rawValue)&start=\(start)"
        let headers = headers
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: Shop.self) { response in
                switch response.result {
                case .success(let data):
                    handler(data)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
