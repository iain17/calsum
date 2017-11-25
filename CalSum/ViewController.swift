//
//  ViewController.swift
//  CalSum
//
//  Created by Iain Munro on 24/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func test() {
        var titles : [String] = []
        var startDates : [Date] = []
        var endDates : [Date] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == "Work" {
                
                let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = Date(timeIntervalSinceNow: +30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
                
                var events = eventStore.events(matching: predicate)
                
                for event in events {
                    titles.append(event.title)
                    startDates.append(event.startDate)
                    endDates.append(event.endDate)
                }
            }
        }
    }

}

