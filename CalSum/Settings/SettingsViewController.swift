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
        defaultSettings()
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
            row.value = Settings.Q1Start
        }
        q1.cellUpdate({ (cell, row) in
            if let date = row.value {
                Settings.Q1Start = date
            }
        })
    
        self.form +++ Section("Quarter settings")
            <<< q1
    }
    
    func defaultSettings() {
       self.form +++ Section("Default settings")
        <<< DecimalRow() {
            $0.title = "Hours"
            $0.value = Double(Settings.DefaultHours)
            let formatter = DecimalFormatter()
            formatter.maximumFractionDigits = 0
            formatter.generatesDecimalNumbers = false
            $0.formatter = formatter
            $0.useFormatterDuringInput = true
            }.cellSetup { cell, _  in
                cell.textField.keyboardType = .numberPad
            }.cellUpdate { (cell, row) in
                if let value = row.value {
                    Settings.DefaultHours = Int(value)
                }
        }
    }

}
