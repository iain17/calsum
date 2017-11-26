//
//  Goal.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import Foundation
import CoreData
import EventKit

public class Goal: NSManagedObject {
    func resetToDefaults() {
        self.from = Date()
        var till = Date()
        till = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: till)!
        self.till = till
        self.hours = Int32(Settings.DefaultHours)
        self.type = "Date range"
    }
}

