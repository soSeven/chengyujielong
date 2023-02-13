//
//  OnlineTimeManager.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/15.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation

class OnlineTimeManager {
    
    static let shared = OnlineTimeManager()
    
    private let onlineTimeKey = "onlineTimeKey"
    let lastTime: Date
    
    init() {
        
        let lastTime = UserDefaults.standard.date(forKey: onlineTimeKey)
        if let lastTime = lastTime, lastTime.isInToday {
            self.lastTime = lastTime
        } else {
            /// 第一次进来
            self.lastTime = Date()
            UserDefaults.standard.setValue(self.lastTime, forKey: onlineTimeKey)
        }
        
    }
    
    func getDifSeconds() -> Double {
        return Date().secondsSince(lastTime)
    }
    
}
