//
//  Day.swift
//  CalSum
//
//  Created by Iain Munro on 29/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import Foundation

class Day {
    //Start of the day
    public let start: Date
    //End of the day
    public let end: Date
    var seconds = [UInt8](repeating: 0, count: 86400)//A day counts 86400 seconds
    private(set) var totalSecondsBooked = 0
    private(set) var totalSecondsOverbooked = 0
    
    init(date: Date, yesterdaySecondsOverbooked: Int = 0) {
        self.start = Foundation.Calendar.current.startOfDay(for: date)
        self.end = Day.endOfDay(rawDate: self.start)
        
        //Handle overbooking from the previous day.
        var till = yesterdaySecondsOverbooked
        if till > 86400 {
            self.totalSecondsOverbooked += till - 86400
            till = 86400
        }
        if till > 0 {
            for i in 0...till-1 {
                self.seconds[i] = UInt8(1)
                self.totalSecondsBooked += 1
            }
        }
    }
    
    class func endOfDay(rawDate: Date) -> Date {
        var date = Foundation.Calendar.current.startOfDay(for: rawDate)
        return Foundation.Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    
    public func book(from: Date, till: Date) {
        var fromSeconds = dateToSeconds(from)
        var toSeconds = dateToSeconds(till)
        //If the date started before this day. Only count the seconds of this day.
        if fromSeconds < 0 {
            fromSeconds = 0
        }
        if toSeconds > 86400 {
            self.totalSecondsOverbooked += toSeconds - 86400
            toSeconds = 86400
        }
        var booked = 0
        for i in fromSeconds...toSeconds-1 {
                if self.seconds[i] == 0 {
                    self.seconds[i] = UInt8(1)
                    booked += 1
                }
        }
        self.totalSecondsBooked += booked
    }
    
    internal func dateToSeconds(_ date: Date) -> Int {
        return Int(date.timeIntervalSince(self.start))
    }
    
//    private func lock(_ obj: Any, blk:() -> ()) {
//        objc_sync_enter(obj)
//        blk()
//        objc_sync_exit(obj)
//    }
}
