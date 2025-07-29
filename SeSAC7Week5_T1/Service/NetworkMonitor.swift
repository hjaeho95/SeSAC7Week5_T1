//
//  NetworkMonitor.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/29/25.
//

import Network

final class NetworkMonitor {
    
    private init() { }
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected = false
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied ? true : false
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
