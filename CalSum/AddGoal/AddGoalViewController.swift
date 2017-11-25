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
            var date = Date()
            date = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: row.value!)!
            till.value = date
        }
        till.cellUpdate { (cell, row) in
            from.maximumDate = till.value
        }
        form +++ Section("Goal date range")
            <<< SegmentedRow<String>("goalType"){
                $0.options = ["Date range", "Quarter", "Year"]
                $0.value = "Date range"
            }
            
            //Date range: custom
            +++ Section("Date range") {
                $0.hidden = "$goalType != 'Date range'"
            }
            <<< from
            <<< till
            
            //Date range: quarter
            +++ Section("Quarter goal") {
                $0.hidden = "$goalType != 'Quarter'"
            }
            <<< PickerInlineRow<Date>("Quater") { (row : PickerInlineRow<Date>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: Date?) in
                    return rowValue.map { "Quarter \(Foundation.Calendar.current.component(.quarter, from: $0))" }
                }
                row.options = []
                var date = Date()
                for _ in 1...10{
                    row.options.append(date)
                    date = date.addingTimeInterval(60*60*24*365)
                }
                row.value = row.options[0]
            }
            
            //Date range: year
            +++ Section("Year goal") {
                $0.hidden = "$goalType != 'Year'"
            }
            <<< PickerInlineRow<Date>("year") { (row : PickerInlineRow<Date>) -> Void in
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
        
            //Goal
            +++ Section("Goal") {
                $0.hidden = false
            }
            <<< DecimalRow() {
                $0.title = "Hours"
                $0.value = 1
                $0.formatter = DecimalFormatter()
                $0.useFormatterDuringInput = true
                //$0.useFormatterOnDidBeginEditing = true
            }.cellSetup { cell, _  in
                cell.textField.keyboardType = .numberPad
            }
    }
    
    
}
