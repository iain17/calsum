//
//  CalSumBrain.swift
//  CalSum
//
//  Created by Iain Munro on 26/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import Foundation
import EventKit
class CalSumBrain {
    private var goal: Goal
    init(goal: Goal) {
        self.goal = goal
    }
    
    public func getTotalHours(completion: @escaping (_ result: Double) -> Void) {
        DispatchQueue.global().async {
            var hours = 0.0
            if var events = self.goal.calendar?.getEvents(from: self.goal.from!, till: self.goal.till!) {
                events = events.sorted(by: { (A, B) -> Bool in
                    return A.startDate < B.startDate
                })
                for event in events {
                    if self.isOverlapped(event: event) {
                        continue
                    }
                    hours += self.getHoursBetween(event.startDate, event.endDate)
                }
            }
            completion(hours)
        }
    }
    
    private func isOverlapped(event: EKEvent) -> Bool {
        //An all day event will always overlap.
        if event.isAllDay {
            return true
        }
        //Check if any of the events are not our event id
        if let events = self.goal.calendar?.getEvents(from: event.startDate, till: event.endDate) {
            //If there is more than one. There will be overlap!
            if events.count != 1 {
                return true
            }
            //Sanity: if the event id is the same we have not overlapped.
            return events[0].eventIdentifier != event.eventIdentifier
        }
        return true
    }
    
    private func getHoursBetween(_ start: Date, _ end: Date) -> Double {
        return Double(end.timeIntervalSince(start)) / 60.0 / 60.0
    }
    
}
