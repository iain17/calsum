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
    
    static var DefaultHours: Int {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: constants.PREF_HOURS) {
                if let value = Int(rawValue) {
                    return value
                }
            }
            return 1225//https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/winst/inkomstenbelasting/inkomstenbelasting_voor_ondernemers/voorwaarden_urencriterium
        }
        set {
            let value = String(newValue)
            UserDefaults.standard.set(value, forKey: constants.PREF_HOURS)
            UserDefaults.standard.synchronize()
        }
    }
    
}
