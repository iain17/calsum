//
//  AddGoalViewController.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit
import Eureka
import Foundation

class AddGoalViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let from = DateRow(){
            $0.title = "From"
            $0.value = Date()
        }
        let till = DateRow(){
            $0.title = "Till"
            $0.value = Date()
        }
        from.cellUpdate { (cell, row) in
            till.minimumDate = from.value
        }
        till.cellUpdate { (cell, row) in
            from.maximumDate = till.value
        }
        form +++ Section("Section A")
            
            <<< SegmentedRow<String>("goalType"){
                //$0.title = ""
                $0.options = ["Date range", "Q1", "Q2", "Q3", "Q4"]
                $0.value = "Date range"
            }
            
            +++ Section("Quarter goal") {
                $0.hidden = "$goalType == 'Date range'"
            }
            <<< PickerInlineRow<Date>("PickerInlineRow") { (row : PickerInlineRow<Date>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: Date?) in
                    return rowValue.map { "Year \(Foundation.Calendar.current.component(.year, from: $0))" }
                }
                row.options = []
                var date = Date()
                for _ in 1...10{
                    row.options.append(date)
                    date = date.addingTimeInterval(60*60*24*365)
                }
                row.value = row.options[0]
            }
            
            +++ Section("Date range") {
                $0.hidden = "$goalType != 'Date range'"
            }
            <<< from
            <<< till
    }
    
    
}
