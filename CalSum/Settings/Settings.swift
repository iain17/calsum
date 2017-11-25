//
//  Settings.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import Foundation

class Settings {
    
    static var Q1Start : Date {
        get {
            var date = Date(timeIntervalSince1970: 0)
            if let rawQ1Value = UserDefaults.standard.string(forKey: constants.PREF_Q1) {
                if let q1Value = Int(rawQ1Value) {
                    date = Foundation.Calendar.current.date(byAdding: .month, value: q1Value, to: date)!
                    return date
                }
            }
            return date
        }
        set {
            let value = String(Foundation.Calendar.current.component(.month, from: newValue) - 1)
            UserDefaults.standard.set(value, forKey: constants.PREF_Q1)
            UserDefaults.standard.synchronize()
        }
    }
    
}
