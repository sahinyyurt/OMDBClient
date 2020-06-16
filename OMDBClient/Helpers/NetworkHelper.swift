//
//  NetworkManager.swift
//  OMDBClient
//
//  Created by Sahin Yesilyurt on 16.06.2020.
//  Copyright © 2020 sahiny. All rights reserved.
//

import Foundation

import Foundation
import Reachability

class NetworkHelper: NSObject {

    var reachability: Reachability!
    
    static let shared: NetworkHelper = { return NetworkHelper() }()
    
    
    private override init() {
        super.init()

        reachability = try! Reachability()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            try (NetworkHelper.shared.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }

    static func isReachable(completed: @escaping (NetworkHelper) -> Void) {
        if (NetworkHelper.shared.reachability).connection != .unavailable {
            completed(NetworkHelper.shared)
        }
    }
    
    static func isUnreachable(completed: @escaping (NetworkHelper) -> Void) {
        if (NetworkHelper.shared.reachability).connection == .unavailable {
            completed(NetworkHelper.shared)
        }
    }
}
