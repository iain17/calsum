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
    
    public func getPercentage(completion: @escaping (_ result: Double) -> Void) {
        self.getTotalHours { (hours) in
            let percentage = hours / self.goal.hours * 100
            completion(percentage)
        }
    }
    
    public func getTotalHours(completion: @escaping (_ result: Double) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var currDate = self.goal.from!
            var overbooked = 0
            var hours = 0.0
            while(currDate <= self.goal.till!) {
                let day = self.getTotalHourOfDay(day: currDate, overbooked: overbooked)
                overbooked = day.totalSecondsOverbooked
                hours += CalSumBrain.secondsToHours(seconds: day.totalSecondsBooked)
                currDate = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: currDate)!
            }
            completion(hours)
        }
    }
    
    private func getTotalHourOfDay(day: Date, overbooked: Int) -> Day {
        let result = Day(date: day, yesterdaySecondsOverbooked: overbooked)
        if let events = self.goal.calendar?.getEvents(from: result.start, till: result.end) {
            for event in events {
                result.book(from: event.startDate, till: event.endDate)
            }
        }
        return result
    }
    
    class func secondsToHours(seconds: Int) -> Double {
        return Double(seconds) / 60 / 60
    }
}
