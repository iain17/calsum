//
//  SettingsViewController.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit
import Eureka
import Foundation

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quarterSettings()
    }
    
    func quarterSettings() {
        let q1 = PickerInlineRow<Date>("Q1") { (row : PickerInlineRow<Date>) -> Void in
            row.title = "First quarter start"
            row.displayValueFor = { (rowValue: Date?) in
                return rowValue.map {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    return formatter.string(from: $0)
                }
            }
            row.options = []
            var date = Date(timeIntervalSince1970: 0)
            for _ in 1...12{
                row.options.append(date)
                date = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: date)!
            }
            row.value = row.options[0]
        }
        q1.cellUpdate({ (cell, row) in
            if let date = row.value {
                self.setQ1(date)
            }
        })
        if UserDefaults.standard.string(forKey: "q1") == nil {
            if let date = q1.value {
                setQ1(date)
            }
        }
        
        self.form +++ Section("Quarter settings")
            <<< q1
    }
    
    func setQ1(_ date: Date) {
        UserDefaults.standard.set("q1", forKey: String(Foundation.Calendar.current.component(.month, from: date)))
    }

}
