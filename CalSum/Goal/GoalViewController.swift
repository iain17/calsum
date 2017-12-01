//
//  GoalViewController.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit
import Eureka
import Foundation
import CoreData

class GoalViewController: FormViewController {
    public var goal: Goal!
    fileprivate let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildType()
        self.buildCustomDateRange()
//        self.buildQuarterRange()
//        self.buildYearRange()
        self.buildGoal()
        
        updateView()
    }
    
    func updateView() {
        if let type = self.goal.type {
            switch(type) {
            case "Date range":
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                let from = formatter.string(from: self.goal.from!)
                let till = formatter.string(from: self.goal.till!)
                goal.name = "\(from)-\(till)"
            break
            default:
                goal.name = "Undefined"
            break
            }
        }
        if let name = goal.name {
            self.title = name
        }
    }
    
    @IBAction func save(_ sender: Any) {
        do {
            try coreDataManager.managedObjectContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            print(error)
        }
    }
    
    func buildType() {
        self.form +++ Section("Type")
            <<< SegmentedRow<String>("goalType"){
                $0.options = ["Date range", "Quarter", "Year"]
                $0.value = self.goal.type
                }.onChange({ (row) in
                    self.goal.type = row.value
                })
    }
    
    func buildCustomDateRange() {
        let from = DateRow(){
            $0.title = "From"
            $0.value = goal.from
        }
        let till = DateRow(){
            $0.title = "Till"
            $0.value = goal.till
        }
        from.cellUpdate { (cell, row) in
            till.minimumDate = row.value
            self.goal.from = row.value
            
            if row.value! >= till.value! {
                var date = Date()
                date = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: row.value!)!
                till.value = date
                till.updateCell()
            }
            self.updateView()
        }
        till.cellUpdate { (cell, row) in
            self.goal.till = row.value
            from.updateCell()
            self.updateView()
        }
        self.form +++ Section("Date range") {
            $0.hidden = "$goalType != 'Date range'"
        }
            <<< from
            <<< till
    }
    
//    func buildQuarterRange() {
//        self.form +++ Section("Quarter goal") {
//            $0.hidden = "$goalType != 'Quarter'"
//            }
//            <<< PickerInlineRow<Date>("Quater") { (row : PickerInlineRow<Date>) -> Void in
//                row.title = row.tag
//                row.displayValueFor = { (rowValue: Date?) in
//                    return rowValue.map { "Quarter \(Foundation.Calendar.current.component(.quarter, from: $0))" }
//                }
//                row.options = []
//                var date = Date()
//                for _ in 1...10{
//                    row.options.append(date)
//                    date = date.addingTimeInterval(60*60*24*365)
//                }
//                row.value = row.options[0]
//        }
//    }
//
//    func buildYearRange() {
//        self.form +++ Section("Year goal") {
//            $0.hidden = "$goalType != 'Year'"
//            }
//            <<< PickerInlineRow<Date>("year") { (row : PickerInlineRow<Date>) -> Void in
//                row.title = row.tag
//                row.displayValueFor = { (rowValue: Date?) in
//                    return rowValue.map { "Year \(Foundation.Calendar.current.component(.year, from: $0))" }
//                }
//                row.options = []
//                var date = Date()
//                for _ in 1...10{
//                    row.options.append(date)
//                    date = date.addingTimeInterval(60*60*24*365)
//                }
//                row.value = row.options[0]
//        }
//    }
    
    func buildGoal() {
        self.form +++ Section("Goal") {
            $0.hidden = false
            }
            <<< DecimalRow() {
                $0.title = "Hours"
                $0.value = Double(self.goal.hours)
                let formatter = DecimalFormatter()
                formatter.minimumFractionDigits = 0
                formatter.generatesDecimalNumbers = false
                $0.formatter = formatter
                $0.useFormatterDuringInput = true
                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }.cellUpdate({ (cell, row) in
                    if let value = row.value {
                        self.goal.hours = value
                    }
                })
    }
    
}
