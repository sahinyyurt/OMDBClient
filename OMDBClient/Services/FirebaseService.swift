//
//  FirebaseService.swift
//  OMDBClient
//
//  Created by Sahin Yesilyurt on 16.06.2020.
//  Copyright © 2020 sahiny. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: NSObject {

    static let shared: FirebaseService = { return FirebaseService() }()
    private var ref:DatabaseReference?

    private override init() {
        super.init()
        ref = Database.database().reference(withPath: "/")
    }
    
    static func getConfig(completed: @escaping (String?) -> Void) {
        let configRef = FirebaseService.shared.ref?.child("config");
        configRef?.observe(DataEventType.value) { (snapshot) in
            completed(snapshot.value as? String)
        }
    }
    
    static func sendMovieAnalytics(id: String,name: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(id)",
            AnalyticsParameterContentType:"moviedetail"
        ])
    }
}
